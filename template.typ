// Typst template converted from Experimental_Report.cls (HUST course design report style)
// Usage:
//   #import "experimental-report.typ": *
//   #show: experimental_report.with(
//     title: "…",
//     course_name: "…",
//     author: "…",
//     school: "…",
//     class_num: "…",
//     stu_num: "…",
//     instructor: "…",
//     report_date: "…",
//   )
//   ... document body ...
#import "@preview/cuti:0.4.0": show-cn-fakebold



#let _cm(x) = x * 1cm

// Rough zihao-to-pt mapping (good-enough visual match in Typst).
#let zihao = (
  // zihao{-0} (初号) is very large; used on cover.
  z0: 42pt,
  // zihao{2}
  z2: 22pt,
  // zihao{3}
  z3: 16pt,
  // zihao{-2}
  zm2: 18pt,
  // zihao{4}
  z4: 14pt,
  // zihao{-4}
  zm4: 12pt,
  // zihao{5}
  z5: 10.5pt,
)

#let _font-latin = "Times New Roman"
// Pick a sensible Windows CJK fallback; users can override if needed.
#let _font-cjk-FangSong = "FangSong"
#let _font-cjk-sans = "Microsoft YaHei"
#let _font-cjk-kaishu = "KaiTi"
#let _font-cjk = "SimSun"



#let _hust_header() = {
  // Red centered header title with a single horizontal line below.
  v(15mm)
  stack(
    spacing: 3mm,
    align(center, text(fill: rgb(192, 0, 0), font: _font-cjk-kaishu, size: 15pt, tracking: 0.3em)[
      华 中 科 技 大 学 课 程 设 计 报 告
    ]),
    stack(
      spacing: 0.4mm,
      line(length: 100%, stroke: 0.5pt + blue),
      line(length: 100%, stroke: 0.5pt + blue),
    ),
    
    v(100mm),
  )
}

#let _hust_footer(footline_length: 6.7cm) = {
  // Centered page number, with left/right rules.
  // LaTeX uses Huawen Zhongsong; approximate with CJK serif.
  grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    inset: (top: 0pt),
    // Left rule
    align(left, rect(width: footline_length, height: 0.4pt, fill: black)),
    // Page number
    align(center, text(font: _font-cjk, size: zihao.z5)[#context counter(page).display("1")]),
    // Right rule
    align(right, rect(width: footline_length, height: 0.4pt, fill: black)),
  )
}

#let _underline_field(body, width: 12em, pad: 2pt) = {
  // A visual underline field like \underline{\makebox[...]{...}}
  // We build a box with only a bottom stroke (no borders).
  box(
    width: width,
    inset: (bottom: pad),
		stroke: (bottom: 0.6pt),
		outset: (bottom: 3pt),
    body,
  )
}

#let _cover(
  title: "",
  course_name: "",
  author: "",
  school: "",
  class_num: "",
  stu_num: "",
  instructor: "",
  report_date: "",
  // Replace the LaTeX EPS logo with a user-supplied raster/vector.
  // If not present, we simply omit it.
  logo_path: none,
  line_width: 12em,
) = {
  // Title page with no header/footer.
  set page(header: none, footer: none)
  // Center everything.
  align(
    center,
    stack(
      spacing: 0pt,
      v(5em),
      (if logo_path != none { image(logo_path, height: 1.61cm) } else { none }),
      v(3em),
      text(font: _font-cjk, size: 40pt, spacing: 0.1em)[*课 程 设 计 报 告*],
      v(8em),
      stack(
        dir: ltr,
        spacing: 0.5em,
        text(font: _font-cjk-sans, size: zihao.z2, weight: "bold")[题目：],
        _underline_field(text(font: _font-cjk, size: zihao.z2, weight: "bold")[#title], width: 26em),
      ),
      v(8em),
      {
        set text(font: _font-cjk, size: 18pt, weight: "bold")
        stack(
          spacing: 1.5em,
          stack(
            dir: ltr,
            spacing: 1em,
            box(width: 6em)[*课程名称*],
            _underline_field(course_name, width: line_width),
          ),
          stack(
            dir: ltr,
            spacing: 1em,
            box(width: 6em)[*专业班级*],
            _underline_field(class_num, width: line_width),
          ),
          stack(
            dir: ltr,
            spacing: 1em,
            box(width: 6em)[*学　　号*],
            _underline_field(stu_num, width: line_width),
          ),
          stack(
            dir: ltr,
            spacing: 1em,
            box(width: 6em)[*姓　　名*],
            _underline_field(author, width: line_width),
          ),
          stack(
            dir: ltr,
            spacing: 1em,
            box(width: 6em)[*指导教师*],
            _underline_field(instructor, width: line_width),
          ),
          stack(
            dir: ltr,
            spacing: 1em,
            box(width: 6em)[*报告日期*],
            _underline_field(report_date, width: line_width),
          ),
        )
      },
      v(5em),
      text(font: _font-cjk-FangSong, size: zihao.z3)[*#school*],
    ),
  )
  
  pagebreak()
}

#let _set_outline_style(depth: 2) = {
  // Use Typst's outline; depth matches LaTeX \tableofcontents[level=2].
  // Title is customized to "目 录" with spacing and dotted leaders.
  show outline: set par(first-line-indent: 0pt)
  
  set outline(indent: auto)
  
  show outline.entry: it => {
    let page_num = counter(page).at(it.element.location()).first()
    let heading_num = if it.element.numbering != none {
      numbering(it.element.numbering, ..counter(heading).at(it.element.location()))
    } else {
      none
    }
    
    let content = if heading_num != none and heading_num.contains(regex("[A-Z]")) {
      [附录#heading_num #it.element.body]
    } else {
      [#heading_num #it.element.body]
    }
    
    if it.level == 1 {
      v(1.5em, weak: true)
      link(it.element.location())[
        #text(font: _font-cjk-sans, size: zihao.z4, weight: "bold")[
          #content
          #box(width: 1fr, repeat[.])
          #h(0.3em)
          #page_num
        ]
      ]
      v(0.5em)
    } else if it.level == 2 {
      link(it.element.location())[
        #text(font: _font-cjk, size: zihao.zm4)[
          #h(3em)
          #if heading_num != none [#heading_num#h(1em)]
          #it.element.body
          #box(width: 1fr, repeat[.])
          #h(0.3em)
          #page_num
        ]
      ]
      v(0.7em, weak: true)
    } else {
      it
    }
  }
  
  v(2em)
  align(center, text(font: _font-cjk-sans, size: zihao.z3, weight: "bold")[
    目#h(2em)录
  ])
  v(1em)
  outline(title: none, depth: depth)
}



#let experimental_report(
  body,
  title: "",
  course_name: "",
  author: "",
  school: "",
  class_num: "",
  stu_num: "",
  instructor: "",
  report_date: "",
  logo_path: none,
  footline_length: 6.7cm,
  toc_depth: 2,
) = {
  show: show-cn-fakebold.with(stroke: 0.04em)

	if logo_path == none {

		logo_path = "./HUSTBlack.png"
	}
  
  // Cover.
  _cover(
    title: title,
    course_name: course_name,
    author: author,
    school: school,
    class_num: class_num,
    stu_num: stu_num,
    instructor: instructor,
    report_date: report_date,
    logo_path: logo_path,
  )
  
  // Main header/footer for the rest of the document.
  
  // Front matter: Roman numbering + TOC.
  set page(
    numbering: "I",
    header: _hust_header(),
    footer: _hust_footer(footline_length: footline_length),
    margin: (top: 1.2in),
  )
  counter(page).update(1)
  _set_outline_style(depth: toc_depth)
  pagebreak()
  
  // Main matter: Arabic numbering.
  set page(
    numbering: "1",
    header: _hust_header(),
    footer: _hust_footer(footline_length: footline_length),
    margin: (top: 1.2in),
  )
  counter(page).update(1)
  
  
  set text(font: (_font-latin, _font-cjk), size: 13pt)
  set par(first-line-indent: 2em, justify: true)
  
  set heading(numbering: "1.1")
  show heading: set par(first-line-indent: 0pt)
  
  show heading.where(level: 1): it => {
    // Add a page break before each section like \sectionbreak could be used.
    // Note: LaTeX defines \sectionbreak but doesn't enforce it; we won't force it.
    align(center, text(font: _font-cjk-sans, size: zihao.zm2, weight: "bold")[#counter(heading).display() #it.body])
    v(0.5em)
  }
  
  // Subsection: left, bold.
  show heading.where(level: 2): it => {
    v(0.5em)
    text(font: _font-cjk-sans, size: zihao.z4, weight: "bold")[#counter(heading).display() #it.body]
    v(0.3em)
  }
  
  // Subsubsection: left, bold, smaller.
  show heading.where(level: 3): it => {
    text(font: _font-cjk-sans, size: zihao.zm4, weight: "bold")[#counter(heading).display() #it.body]
  }
  
  // Place table captions on top
  show figure.where(kind: table): set figure(gap: 0.5em)
  show figure.where(kind: table): it => {
    v(0.5em)
    it.caption
    v(0.3em)
    it.body
    v(0.5em)
  }
  
  body
}


// from: https://github.com/DzmingLi/hust-cse-report/blob/main/template.typ , thanks!
#let tbl(content, caption: "") = {
  show figure.where(
    kind: table,
  ): set figure.caption(position: top)
  figure(
    content,
    caption: text(font: ("Times New Roman", "SimHei"), size: 12pt)[#caption],
    supplement: text(font: _font-cjk)[表],
    numbering: (..nums) => {
      let values = nums.pos()
      if values.len() == 1 {
        context {
          let section = counter(heading).get()
          if section.len() >= 2 {
            numbering("1-1-1", section.at(0), section.at(1), values.at(0))
          } else if section.len() == 1 {
            numbering("1-1", section.at(0), values.at(0))
          } else {
            numbering("1", values.at(0))
          }
        }
      }
    },
    kind: table,
    placement: none,
  )
}

// from: https://github.com/DzmingLi/hust-cse-report/blob/main/template.typ , thanks!
#let fig(image-path, caption: "", width: auto) = {
  figure(
    image(image-path, width: width),
    caption: text(font: ("Times New Roman", "SimHei"), size: 12pt)[#caption],
    supplement: [图],
    numbering: (..nums) => {
      let values = nums.pos()
      if values.len() == 1 {
        context {
          let section = counter(heading).get()
          if section.len() >= 2 {
            numbering("1-1-1", section.at(0), section.at(1), values.at(0))
          } else if section.len() == 1 {
            numbering("1-1", section.at(0), values.at(0))
          } else {
            numbering("1", values.at(0))
          }
        }
      }
    },
  )
}

#let citation(bib_path) = {
  // Create a level 1 heading without numbering
  show heading.where(level: 1): it => {
    align(center, text(font: _font-cjk-sans, size: zihao.zm2, weight: "bold")[#it.body])
  }
  heading(level: 1, numbering: none)[参考文献]
  
  // Display the bibliography
  bibliography(bib_path, title: none, full: true)
}

#let appendix_section(body) = {
  
  set heading(numbering: "A")
  counter(heading).update(0)
  show heading.where(level: 1): it => {
    align(center, text(font: _font-cjk-sans, size: zihao.zm2, weight: "bold")[附录#counter(heading).display() #it.body])
  }
  body
}
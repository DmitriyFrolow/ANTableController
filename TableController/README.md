
=================
Adoption of DTTableViewController for using without UIViewController sublassing 

- Hadles Apple's bug, when UITablViewStyle is plain, and bottom section separator doesn't visible in 1 section table.
- For transparent cell, or cell/header/footer set property isTransparent = YES; and set transparent color to your contentView

- for enabling logging - 
#define AN_TABLE_LOG
# vim-node-import

```js
r fs⏎
```

Turns into:

```js
const fs = require('fs')
```

Also:

```js
r path        → const path = require('path')
r ../setup    → const setup = require('../setup')
r path.join   → const join = require('path').join
r React       → const React = require('react')

v path        → var path = require('path')

i path        → import path from 'path'
i path.join   → import { join } from 'path'
```

Semicolons are added if any other line in your buffer ends in a semicolon.

<br>

## Thanks

**vim-node-import** © 2015+, Rico Sta. Cruz. Released under the [MIT] License.<br>
Authored and maintained by Rico Sta. Cruz with help from contributors ([list][contributors]).

> [ricostacruz.com](http://ricostacruz.com) &nbsp;&middot;&nbsp;
> GitHub [@rstacruz](https://github.com/rstacruz) &nbsp;&middot;&nbsp;
> Twitter [@rstacruz](https://twitter.com/rstacruz)

[MIT]: http://mit-license.org/
[contributors]: http://github.com/rstacruz/vim-node-import/contributors

# vim-node-import

```js
require fs⏎
```

turns into:

```js
const fs = require('fs')
```

also:

```js
require path          → const path = require('path')
require ../setup      → const setup = require('../setup')
require path.join     → const join = require('path').join

var path              → var path = require('path')

import path           → import path from 'path'
import path.join      → import { join } from 'path'
```

Also, *require* can be shortened to `r`, *var* to `v`, and *import* to `i`.

<br>

## Thanks

**vim-node-import** © 2015+, Rico Sta. Cruz. Released under the [MIT] License.<br>
Authored and maintained by Rico Sta. Cruz with help from contributors ([list][contributors]).

> [ricostacruz.com](http://ricostacruz.com) &nbsp;&middot;&nbsp;
> GitHub [@rstacruz](https://github.com/rstacruz) &nbsp;&middot;&nbsp;
> Twitter [@rstacruz](https://twitter.com/rstacruz)

[MIT]: http://mit-license.org/
[contributors]: http://github.com/rstacruz/vim-node-import/contributors

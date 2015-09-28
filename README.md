# vim-node-import

```js
fs<ctrl-e>
```

turns into:

```js
const fs = require('fs')
```

also:

```js
path          → const path = require('path')
../setup      → const setup = require('../setup')
path.join     → const join = require('path').join
```

<br>

## Thanks

**vim-node-import** © 2015+, Rico Sta. Cruz. Released under the [MIT] License.<br>
Authored and maintained by Rico Sta. Cruz with help from contributors ([list][contributors]).

> [ricostacruz.com](http://ricostacruz.com) &nbsp;&middot;&nbsp;
> GitHub [@rstacruz](https://github.com/rstacruz) &nbsp;&middot;&nbsp;
> Twitter [@rstacruz](https://twitter.com/rstacruz)

[MIT]: http://mit-license.org/
[contributors]: http://github.com/rstacruz/vim-node-import/contributors

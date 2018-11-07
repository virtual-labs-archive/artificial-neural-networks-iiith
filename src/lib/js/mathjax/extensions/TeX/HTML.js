/*
 *  /MathJax/extensions/TeX/HTML.js
 *  
 *  Copyright (c) 2010 Design Science, Inc.
 *
 *  Part of the MathJax library.
 *  See http://www.mathjax.org for details.
 * 
 *  Licensed under the Apache License, Version 2.0;
 *  you may not use this file except in compliance with the License.
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 */

MathJax.Hub.Register.StartupHook("TeX Jax Ready",function(){var b="1.1";var c=MathJax.InputJax.TeX;var a=c.Definitions;a.macros.href="HrefAttribute";a.macros["class"]="ClassAttribute";a.macros.style="StyleAttribute";a.macros.cssId="IdAttribute";c.Parse.Augment({HrefAttribute:function(f){var e=this.GetArgument(f),d=this.GetArgumentMML(f);this.Push(d.With({href:e}))},ClassAttribute:function(e){var f=this.GetArgument(e),d=this.GetArgumentMML(e);if(d["class"]!==null){f=d["class"]+" "+f}this.Push(d.With({"class":f}))},StyleAttribute:function(e){var f=this.GetArgument(e),d=this.GetArgumentMML(e);if(d.style!=null){if(f.charAt(f.length-1)!==";"){f+=";"}f=d.style+" "+f}this.Push(d.With({style:f}))},IdAttribute:function(f){var e=this.GetArgument(f),d=this.GetArgumentMML(f);this.Push(d.With({id:e}))},GetArgumentMML:function(e){var d=this.ParseArg(e);if(d.inferred&&d.data.length===1){d=d.data[0]}else{delete d.inferred}return d}});MathJax.Hub.Startup.signal.Post("TeX HTML Ready")});MathJax.Ajax.loadComplete("[MathJax]/extensions/TeX/HTML.js");


From: Philippe =?ISO-8859-15?Q?Gramoull=E9?=
	<philippe.gramoulle@mmania.com>
Subject: Re: mdadm can't start RAID0 volume after power failure
Date: Sat, 18 Dec 2004 02:41:50 +0100
Message-ID: <20041218024150.4ead56af.philippe.gramoulle@mmania.com>
References: <128.5252547e.2ef47a40@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <128.5252547e.2ef47a40@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello Andy,

On Fri, 17 Dec 2004 13:06:56 EST
AndyLiebman@aol.com wrote:

  | 
  | Phillipe
  | 
  | >Still, this is the first time that such a thing happens to me. What could be 
  | the reason that >UUID would be changed ?
  | 
  | If I were a betting person, I would say that the mdadm.conf file was old,

Yes it was, the filesystem was created last February.

  |  and  that you had created a new array since the time you made that conf file. And 
  | you just didn't update the conf file. 

Nope, nothing has changed since, no new array was created nor deleted nor modified.

  | 
  | As I'm sure you know, you don't need to use a conf file anyway to use mdadm. 

Yes, i used a straightforward mdadm command to create the array, 

  | That's what makes it so beautiful! All kinds of things -- like device ids -- 
  | can change on your system and mdadm just figures it out (provided you give it a 
  | minimal amount of info, like the correct uuid!). 

Sure, but again, _nothing_ had changed between last February and today, at least regarding hardware
and kernel. I regularly updated the Debian packages, including mdadm, but i don't think that was the problem

The mdadm.conf is the one from when the array was created, and until today i have shutdown and powered on the box
right fine, for weeks and months.

Maybe someone will be able to explain how the UUID can change on the disks, so that what's on disk and
what's in the conf can get out of sync.
  | 
  | Glad to help :)

You made my day :)

Thanks,

Philippe

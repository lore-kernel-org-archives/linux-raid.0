From: NeilBrown <neilb@suse.de>
Subject: Re: polishing up mdadm manpages: mdassemble(8), mdmon(8)
Date: Thu, 10 Mar 2011 16:18:27 +1100
Message-ID: <20110310161827.6df62c7a@notabene.brown>
References: <daeaad7c9ff2fa76529ad5b58994ba3e@imap.dd24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <daeaad7c9ff2fa76529ad5b58994ba3e@imap.dd24.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 08 Mar 2011 03:08:11 +0000 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> Hi.
> 
> Recently I've started to read into MD/mdadm and what started then as
> maintaining a quilt patch with several typos and so ended up in a somewhat
> "bigger" rework.

Thanks for putting this effort in...
However just getting a new copy of the file isn't much use.
Patches are really required.  Preferably several patches if there
are several different sorts of changes, as I might want to accept 
some but not others.

Of course I could create the patch my - it looks like you 
start from the verison in the 3.2 release - correct?
> 
> - The text iself is (hopefully) largely the same, perhaps apart from some
> wording, or ordering.
> - More consistent usage of markup:
>   -bold for programs, options, files, manpage references (except in the
> SEE ALSO section) and text the is somehow set or "entered"
>   -italitcs (which is typically displayed as underlined) for any
> non-terminals.

Being consistent is good, but using \fB \fI etc is not.
Convention (as I understand it) prefers .B .I etc.
There are a variety of programs around which convert man pages to
other formats and I trust the ".B" tags to be handled more reliably.


> - Consistent writing of words like Linux, RAID, program names (which were
> previously off mixed) apart from those places where they're options (e.g.
> raid1 is still raid1 and not RAID1 for the --level option).

A patch which just made a change like this would certainly be appreciated.

> - Completely rewritten the formatting of the manpage (the dozens of .B, .I
> ... just to format one word made the source file really unreadable IMHO).
> 
> In mdmon(8) there were some places where changed things that could
> possibly changing the semantics:
> - mdadm --remove <container> <victim>   =>   mdadm --remove CONTAINER
> DEVICE

That looks OK.

> - with  a metadata version string "external:<metadata name>"   =>   with a
> metadata format string "external:format"
> - .pid and .sock files   =>   PID and socket files
> 

Maybe... The ".pid" and ".sock" are file name extensions.  If your change
were made (which quite possibly improves readability) it might then me
necessary to say something explicit about extensions.

> I wasn't sure about the following so didn't change it:
> - <disk>/state - faulty
>   Is <disk> a non-terminal for a device (and thus should I replace it with
> an italics "device"?

<disk> here is a non-terminal.  Actually it probably should be

  rdNN/state
where NN is the slot number in the array.

> - (for example, the metadata version has been set to "external:-dev/md127"
> instead of "external:/dev/md127")
>   Is the "version" correct here?

It should be "metadata_version" which is a literal file name.

> 
> 
> I've also started to rewrite md(4), mdadm(8) and mdadm.conf(5) manpges...
> - unifying many further writings of words like "read-only/readonly",
> "read-write/readwrite", etc. pp.
> - etc.
> but I'm not sure if/when I can finish them.

If you have discrete patches for each change, then feel free to send what
you manage, whether it is finished or not.


> 
> 
> Sorry for not sending a (easily reviewable) patch, but there were so many
> changes (in the line wrapping and so), that this did not make much sense.
> Please tell me whether you like and will apply it, so that I can continue
> with the remaining manpages.
> Anyway, if you merge them, please _really_ read them again for
> mistakes/typos I might have accidentally added...!
> 
> 
> Thanks,
> Chris.

NeilBrown


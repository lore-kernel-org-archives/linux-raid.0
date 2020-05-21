From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: failed disks, mapper, and "Invalid argument"
Date: Thu, 21 May 2020 12:55:26 +0100
Message-ID: <5EC66C2E.90901@youngman.org.uk>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk> <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk> <20200521110103.GG1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200521110103.GG1415@justpickone.org>
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg@justpickone.org>, Linux RAID list <linux-raid@vger.kernel.org>
Cc: Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

On 21/05/20 12:01, David T-G wrote:
> Wols, et al --
> 
> ...and then Wols Lists said...
> % 
> % On 21/05/20 00:53, David T-G wrote:
> % >   ## parted
> % >   Model: ATA ST4000DM000-1F21 (scsi)
> ...
> % >   SCT capabilities:              (0x1085) SCT Status supported.
> % >   SMART Error Log Version: 1
> % >   ## scterc
> % >   SCT Error Recovery Control command not supported
> % > 
> % > Curiously, note that querying just scterc as the wiki instructs says "not
> % > supported", but a general smartctl query says yes.  I'm not sure how to
> % > interpret this...
> % 
> % Seagate Barracudas :-(
> 
> Yep.  They were good "back in the day" ...
> 
Still are. Just not for raid..
> 
> % 
> % As for smartctl, you're asking two different things. Firstly is SCT
> % supported (yes). Secondly, is the ERC feature supported (no).
> % 
> % And that second question is the killer. Your drives do not support error
> % recovery. Plan to replace them with ones that do ASAP!
> 
> That would be nice.  I actually have wanted for quite some time
> to grow these from 4T to 8T, but budget hasn't permitted.  Got any
> particularly-affordable recommendations?

8TB WD Reds are still CMR and okay AT THE MOMENT. I wouldn't trust them
though (or make sure you can RMA them if they've changed!)

I haven't heard of Ironwolves using SMR (yet).

Looking quickly on Amazon
WD Red 8TB                  £232
Toshiba N300 8TB            £239
Seagate Ironwolf 8TB        £260
Seagate Ironwolf 8TB Silver £263 (optimised for raid it claims)
WD Red 8TB Pro              £270
Seagate Ironwolf 8TB Pro    £360

Given that the Red and the N300 are similar in price, I'd go for the
N300. Bear in mind that I *never* see those drives mentioned here, I
really don't know what they're like.

Going up a bit, Ironwolf or Red Pro? My personal preference is Ironwolf.
The Reds were always preferred on the list, but WD have really dropped
the ball with making some of these drives SMR. These SMR drives *don't*
*work* in raid full stop, which is bad seeing as they are marketed as
raid drives! I don't know about Ironwolf Silver, but if it's optimised
for raid the £3 is worth it :-)

Ironwolf Pro? Probably overkill.

On all of these, caveat emptor. I'm in the UK, so if the web page or
marketing blurb says "suitable for raid", then I can RMA them as "unfit
for purpose". I don't know what your legal regime is.
> 
> This whole problem sounds familiar to me.  I thought that it was possible
> to adjust the timeouts on the software side to match the longer disk time
> or similar.  Of course, I didn't know that I had a real problem in the
> first place ...  But does that sound familiar to anyone?
> 
 :-) :-) :-)
> 
> % 
> ...
> % 
> % In the meantime, make sure you're running Brad's script, and watch out
> % for any hint of lengthening read/write times. That's unlikely to be why
> % your overlay drives won't mount - I suspect a problem with loopback, but
> % I don't know.
> 
> I most definitely also want to be able to spot trends to get ahead of
> failures.  I just don't know for what to look or how to parse it to write
> a script that will say "hey, this thingie here is growing, and you said
> you cared ...".
> 
> 
> % 
> % What I don't want to advise, but I strongly suspect will work, is to
> % force-assemble the two good drives and the nearly-good drive. Because it
> % has no redundancy it won't scramble your data because it can't do a
> 
> Should I, then, get rid of the mapper overlay stuff?  I tried pointing to
> even just three devs and got that they're busy.
> 
> 
> % rebuild, but I would VERY STRONGLY suggest you download lsdrv and get
> % the output. The whole point of this script is to get the information you
> 
> You mean the output that is some error and a few lines of traceback?
> Yeah, I saw that, but I don't know how to fix it.  Another problem in the
> queue.
> 
Last time I ran it, it was Python 2.7. I needed to edit the shebang
line. I think Phil's fixed that.
> 
> % need so that if everything does go pear shaped, you can rebuild the
> % metadata from first principles. It's easy - git clone, run.
> 
> ... and then debug ;-)
> 
> 
> % 
> % Cheers,
> % Wol
> 
> 
> Thanks again & HAND
> 
> :-D
> 

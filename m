From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Recent drive errors
Date: Tue, 19 May 2015 23:38:16 -0600
Message-ID: <358052151.1yasTJDDbz@balsa>
References: <3296560.sGbn0HyrQY@balsa> <555B4E0F.9020306@turmel.org> <34123545.0U2U7Wo4pc@balsa>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34123545.0U2U7Wo4pc@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue 19 May 2015 10:07:49 AM Thomas Fjellstrom wrote:
> On Tue 19 May 2015 10:51:59 AM you wrote:
> > On 05/19/2015 10:32 AM, Thomas Fjellstrom wrote:
> > > On Tue 19 May 2015 09:23:20 AM Phil Turmel wrote:
> > >> Depends.  In a properly functioning array that gets scrubbed
> > >> occasionally, or sufficiently heavy use to read the entire contents
> > >> occasionally, the UREs get rewritten by MD right away.  Any UREs then
> > >> only show up once.
> > > 
> > > I have made sure that it's doing regular scrubs, and regular SMART
> > > scans.
> > > This time...
> > 
> > Yes, and this drive was kicked out.  Because it wouldn't be listening
> > when MD tried to write over the error it found.
> 
[snip]
> 
> > I posted this link earlier, but it is particularly relevant:
> > http://marc.info/?l=linux-raid&m=133665797115876&w=2
> > 
> > >> Interesting.  I suspect that if you wipe that disk with noise, read it
> > >> all back, and wipe it again, you'll have a handful of relocations.
> > > 
> > > It looks like each one of the blocks in that display is 128KiB. Which i
> > > think means those red blocks aren't very far apart. Maybe 80MiB apart?
> > > Would it reallocate all of those? That'd be a lot of reallocated
> > > sectors.
> > 
> > Drives will only reallocate where a previous read failed (making it
> > pending), then write and follow-up verification fails.  In general,
> > writes are unverified at the time of write (or your write performance
> > would be dramatically slower than read).
> 
> Right. I was just thinking about how you mentioned that I'd get a handful of
> reallocations based on the latency shown in the image I posted. It's a lot
> of sectors that seem to be affected by the latency spikes, so I assumed
> (probably wrongly) that many of them may be reallocated afterwards.
> 
> If this drive ends up not reallocating a single sector, or only a few, I may
> just keep it around as a hot spare, though i feel that's not the best idea,
> if it is degrading, then when it actually goes to use that disk it has a
> higher chance of failing.

Well here's something:

[78447.747221] sd 0:0:15:0: [sdf] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[78447.749092] sd 0:0:15:0: [sdf] Sense Key : Medium Error [current] 
[78447.751034] sd 0:0:15:0: [sdf] Add. Sense: Unrecovered read error
[78447.752925] sd 0:0:15:0: [sdf] CDB: Read(16) 88 00 00 00 00 00 ef 7a 0f b0 00 00 00 08 00 00
[78447.754746] blk_update_request: critical medium error, dev sdf, sector 4017754032
[78447.756700] Buffer I/O error on dev sdf, logical block 502219254, async page read
<many many more of the above>

  5 Reallocated_Sector_Ct   PO--CK   087   087   036    -    17232
187 Reported_Uncorrect      -O--CK   001   001   000    -    8236
197 Current_Pending_Sector  -O--C-   024   024   000    -    12584
198 Offline_Uncorrectable   ----C-   024   024   000    -    12584

Badblocks is showing a bunch of errors now, and the above is what's in dmesg and smartctl.

So I guess it was dead after all.

> > >> You have it backwards.  If you have WD Reds, they are correct out of
> > >> the
> > >> box.  It's when you *don't* have ERC support, or you only have desktop
> > >> ERC, that you need to take special action.
> > > 
> > > I was under the impression you still had to enable ERC on boot. And I
> > > /thought/ I read that you still want to adjust the timeouts, though not
> > > the
> > > same as for consumer drives.
> > 
> > Desktop / consumer drives that support ERC typically ship with it
> > disabled, so they behave just like drives that don't support it at all.
> > 
> >  So a boot script would enable ERC on drives where it can (and not
> > 
> > already OK), and set long driver timeouts on the rest.
> > 
> > Any drive that claims "raid" compatibility will have ERC enabled by
> > default.  Typically 7.0 seconds.  WD Reds do.  Enterprise drives do, and
> > have better URE specs, too.
> 
> Good to know.
> 
> > >> If you have consumer grade drives in a raid array, and you don't have
> > >> boot scripts or udev rules to deal with timeout mismatch, your *ss is
> > >> hanging in the wind.  The links in my last msg should help you out.
> > > 
> > > There was some talk of ERC/TLER and md. I'll still have to find or write
> > > a
> > > script to properly set up timeouts and enable TLER on drives capable of
> > > it
> > > (that don't come with it enabled by default).
> > 
> > Before I got everything onto proper drives, I just put what I needed
> > into rc.local.
> 
[snip]
> 
> > Chris Murphy posted some udev rules that will likely work for you.  I
> > haven't tried them myself, though.
> > 
> > https://www.marc.info/?l=linux-raid&m=142487508806844&w=3
> 
> Thanks :)
> 
> > Phil
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca

From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Was Re: Question - - - - now: issue resolved
Date: Fri, 7 Feb 2020 18:56:20 -0600
Message-ID: <CAPpdf58wY2G4XpNhfnHG42fHkpT6Z_EtLnLdtTaGvhRG_N5KKA@mail.gmail.com>
References: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
 <7af58e5b-7047-a3a8-f4b2-840ea6851dea@prgmr.com> <CAPpdf58BTV5duFoSfdC6_07+kqQy0zgfq4=PgErJHqVeikjgBA@mail.gmail.com>
 <1faaef72-62ed-2c36-19d7-f6995691779f@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1faaef72-62ed-2c36-19d7-f6995691779f@prgmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sarah Newman <srn@prgmr.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 7, 2020 at 5:41 PM Sarah Newman <srn@prgmr.com> wrote:
>
> On 2/7/20 3:21 PM, o1bigtenor wrote:
> > On Fri, Feb 7, 2020 at 4:50 PM Sarah Newman <srn@prgmr.com> wrote:
> >>
> >> On 2/7/20 7:49 AM, o1bigtenor wrote:
> >>> Greetings
> >>>
> >>> Running a Raid-10 array made up of 4 - 1 TB drives on a debian testing
> >>> (11) system.
> >>> mdadm - v4.1 - 2018-10-01 is the version being used.
> >>>
> >>> Some weirdness is happening - - - vis a vis - - - I have one directory
> >>> (not small) that has disappeared. I last accessed said directory
> >>> (still have the pdf open which is how I could get this information)
> >>> 'Last accessed 2020-01-19 6:32 A.M.'  as indicated in the 'Properties'
> >>> section of the file in question.
> >>
> >
> > Greetings
> >
> >
> >> I assume you've looked at lsof?
> >
> > No I hadn't - - - - thanks for the tip.
> > only a few thousand line in a terminal - - - - - but nothing what I was
> > looking for.
> >>
> >> https://www.linux.com/news/bring-back-deleted-files-lsof/
> >>
> >> If it is a software problem, it just as likely, if not more likely, that it is a file system problem rather than a raid problem. You don't mention
> >> what file system. You're possibly also actually looking at data in the in-memory disk cache rather than what's actually stored on disk given there's
> >> been no reboot.
> >
> > The array (raid-10) is on ext4.
> >>
> >> Is there anything suspicious in dmesg?
> >
> > I hadn't looked at the messages files in /var/log so I went back to
> > date in question.
> > Didn't see anything there either.
>
> I said the command dmesg, not /var/log.
>
> If systemd-journald is broken, or your file system is broken, you could have tons of error messages in dmesg and nothing logged to disk.
>

Found one couplet - - - it might be applicable (please advise):

[12458.717443] EXT4-fs (md0p1): warning: maximal mount count reached,
running e2fsck is recommended
[12459.215097] EXT4-fs (md0p1): mounted filesystem with ordered data
mode. Opts: (null)

> >
> > What about doing this:
> >
> > Made the array read only.
> > Copy the whole array using dd to a larger array on a different machine
> > (good overnight job).
> > Then run something like testdisk on the whole array.
> > The last would largely be a waste of time as what has
> > disappeared is one of about 40 upper level directories  and
> > it likely contained about 10 to 50 GB of files (dunno how many
> > levels of directories though - - - I use LOTS).
> >
> > I'm looking for a reasonably solid method of trying to recover
> > this directory and all of its contents (about 8 years worth of
> > putting things into it so replicating it - - - - tough!).
>
> Making the original data read-only and operating on a copy of it is a reasonable idea.

Reading the 'man' page I think the command to change the array to read-only
would be mdadm /name/of/array --readonly

Is that correct?
>
> You probably want http://extundelete.sourceforge.net/ though I would first try
>
> find / -name "somefileyouknowthenameof"
>
> just to make sure it hasn't been moved elsewhere on accident. That seems like the most likely scenario given the lack of error messages, unless no
> messages at all have been logged due to previously mentioned issues.
>
Ran the suggested - - - - - well - - - - somehow I managed to drop the directory
into a much smaller one. Dunno how that happened or any details (if someone
cares to give method(s) and means for determining that I would be very
grateful!) but I have now found the missing directory and its contents
seem to be intact.

I did understand that maybe asking on the linux-raid 'exchange' might not
have been the 'best' place to do so but this seemed quite weird and the
directory was on a raid-array and I thought that maybe this could be a signal
that there were more issues brewing. That seems now not to be the case.

Thank you to those who took the time to give suggestions or ideas with
the end result that the issue was resolved!!

Thanks a muchly!!!!
(hope that the subject change and adding that the issue was resolved
is appropriate
for this group)

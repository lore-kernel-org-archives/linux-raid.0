From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Question
Date: Fri, 7 Feb 2020 17:21:36 -0600
Message-ID: <CAPpdf58BTV5duFoSfdC6_07+kqQy0zgfq4=PgErJHqVeikjgBA@mail.gmail.com>
References: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
 <7af58e5b-7047-a3a8-f4b2-840ea6851dea@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7af58e5b-7047-a3a8-f4b2-840ea6851dea@prgmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sarah Newman <srn@prgmr.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 7, 2020 at 4:50 PM Sarah Newman <srn@prgmr.com> wrote:
>
> On 2/7/20 7:49 AM, o1bigtenor wrote:
> > Greetings
> >
> > Running a Raid-10 array made up of 4 - 1 TB drives on a debian testing
> > (11) system.
> > mdadm - v4.1 - 2018-10-01 is the version being used.
> >
> > Some weirdness is happening - - - vis a vis - - - I have one directory
> > (not small) that has disappeared. I last accessed said directory
> > (still have the pdf open which is how I could get this information)
> > 'Last accessed 2020-01-19 6:32 A.M.'  as indicated in the 'Properties'
> > section of the file in question.
>

Greetings


> I assume you've looked at lsof?

No I hadn't - - - - thanks for the tip.
only a few thousand line in a terminal - - - - - but nothing what I was
looking for.
>
> https://www.linux.com/news/bring-back-deleted-files-lsof/
>
> If it is a software problem, it just as likely, if not more likely, that it is a file system problem rather than a raid problem. You don't mention
> what file system. You're possibly also actually looking at data in the in-memory disk cache rather than what's actually stored on disk given there's
> been no reboot.

The array (raid-10) is on ext4.
>
> Is there anything suspicious in dmesg?

I hadn't looked at the messages files in /var/log so I went back to
date in question.
Didn't see anything there either.

What about doing this:

Made the array read only.
Copy the whole array using dd to a larger array on a different machine
(good overnight job).
Then run something like testdisk on the whole array.
The last would largely be a waste of time as what has
disappeared is one of about 40 upper level directories  and
it likely contained about 10 to 50 GB of files (dunno how many
levels of directories though - - - I use LOTS).

I'm looking for a reasonably solid method of trying to recover
this directory and all of its contents (about 8 years worth of
putting things into it so replicating it - - - - tough!).

Thanks for the assistance!

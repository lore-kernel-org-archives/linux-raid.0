From: kclair <kclair@gmail.com>
Subject: Re: adding a disk smaller than the array size
Date: Wed, 13 Oct 2004 17:06:10 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <dff375270410131406572e5ec8@mail.gmail.com>
References: <dff3752704101313303d344fb8@mail.gmail.com>
	 <200410132254.22483.maarten@ultratux.net>
Reply-To: kclair <kclair@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410132254.22483.maarten@ultratux.net>
To: maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am using raid 1 - sorry for the incomplete information.

The situation is that the array was comprised of two disks, one
slightly smaller than the other.  I did need to remove the smaller of
the disks to fix a partition problem, but now I am unable to add it
back, presumably because the size of the array grew to the size of the
larger disk when the smaller disk was removed?

It is my understanding that the size of the array is not equal to the
amount of data that is actually on the disks.  Is this not true?

I tried to resize the array using mdadm, but that did not work (I got
an error saying the file exists).

The array now only consists of the one larger disk.  If I try to
reassemble the array with both disks, will the information from the
larger disk get synced to the other disk?  Or is there something else
I need to do?

Thanks,
Kristina

On Wed, 13 Oct 2004 22:54:22 +0200, maarten <maarten@ultratux.net> wrote:
> On Wednesday 13 October 2004 22:30, kclair wrote:
> > Hello,
> >
> > I am trying to figure out how I can add a disk that is smaller than
> > the size of the raid array to the array.  I'm confused about whether
> > simply rebuilding the array with the new disk will work?
> 
> Well that is surely a rather incomplete question, since you do not even
> mention which raid level you're talking about.
> 
> That said, I don't think this is possible, in most cases. Raid 5 cannot use a
> disk which is smaller than its peers AFAIK, and neither can raid 1.
> Obviously too, since they cannot be expected to just 'throw away' part of
> their data...
> Whether raid 0 and/or JBOD can I don't know; sure they can be _built_ with all
> sorts of differing drive sizes, but I seem to recall those levels are not
> supported by any on- or offline resizing tool (and they are by definition not
> fault-tolerant so the issue of _replacing_ a drive is thereby moot...).
> 
> If you're looking for trouble / complexity you could consider to make a raid 0
> array out of two smaller drives, and add that combo to your existing raid
> set.  Don't know if raid 5 will accept that, but raid 1 will.  But such
> solutions will probably not contribute to stability and reliability...
> 
> Hope that answered your question,
> Maarten
> 
> > Thanks in advance for any advice,
> > Kristina
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> When I answered where I wanted to go today, they just hung up -- Unknown
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Reshaping RAID-0?
Date: Sat, 05 Feb 2011 00:36:30 +0000
Message-ID: <4D4C9B8E.4090502@anonymous.org.uk>
References: <AANLkTinWzDmEHYWoqFeEoXqQhutj=kG-tgJd7BqERgNF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinWzDmEHYWoqFeEoXqQhutj=kG-tgJd7BqERgNF@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/02/2011 23:32, Patrick J. LoPresti wrote:
> Well, it has been 11 months since I last asked
> (http://www.spinics.net/lists/raid/msg27676.html), and some recent
> patches mention this in the context of "imsm", whatever that is...
>
> So, is it possible to add a disk to a Linux md RAID-0 array and
> re-stripe?  If so, what is the procedure and the required kernel/mdadm
> version(s)?
>
> If not, and if I want to contribute to an implementation effort, where
> would I begin?
>
> Thanks!

I think the capability is in mdadm 3.2, a developer-only release about 4 
days ago, or it's in Neil Brown's 3.2 devel branch. Take a closer look 
at the list archives for the last few days.

As for using it, it'll be the usual syntax, e.g. `mdadm /dev/mdX --add 
/dev/newdisc; mdadm /dev/mdX --grow --raid-disks=3`.

Hope this helps.

Cheers,

John.


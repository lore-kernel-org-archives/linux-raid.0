From: "Majed B." <majedb@gmail.com>
Subject: Re: Growing after replacing with larger discs
Date: Fri, 12 Mar 2010 21:00:37 +0300
Message-ID: <70ed7c3e1003121000q3cfb5eddt7ebd496cdd5f2e1a@mail.gmail.com>
References: <4B9A7C63.6090202@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9A7C63.6090202@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm not sure if it is going to work or not, what you suggested.

But if you can run all disks at the same time, then why not create a
new array and copy the files over?

On Fri, Mar 12, 2010 at 8:39 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> Before I have to go to a customer's premises and try it, I wanted to =
ask if
> anyone had already done anything like this: I have a CentOS 5 system =
with
> 0.90 metadata and type fd partitions with RAID-5 over 3 discs. I want=
 to
> grow it by replacing the drives. If I dd the small partitions onto la=
rger
> ones on the new discs, then reboot, will the system recognise the RAI=
D-5 -
> which now has its metadata somewhere in the middle of the paritions n=
ot at
> the end - so that I can then --grow?
>
> Cheers,
>
> John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

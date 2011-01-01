From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Guidance on how to best assemble new root drive?
Date: Sat, 01 Jan 2011 20:27:40 +0000
Message-ID: <4D1F8E3C.1000006@anonymous.org.uk>
References: <AANLkTi=eU7Z8OaiAkEkatoN3-U67LEYcB5reB1f27QyU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=eU7Z8OaiAkEkatoN3-U67LEYcB5reB1f27QyU@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/01/2011 19:47, Mark Knecht wrote:
[...]
> Is there a way to rename the array in the SuperBlock?

mdadm --update=homehost
mdadm --update=name

> Should I bother? I may go back and forth between these two Gentoo
> installations for a while and want the RAID to be available in both,
> at least until I delete the old RAID1 system to recapture the disk
> space.

I wouldn't have changed hostname, but if your new root is on the RAID-6 
yes I'd change its homehost to suit its hostname. You will then have to 
tell the old RAID-1 to start the array using the new homehost.

Cheers,

John.


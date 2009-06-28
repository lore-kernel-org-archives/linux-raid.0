From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Adding a smaller drive
Date: Sun, 28 Jun 2009 20:05:14 +0100
Message-ID: <4A47BEEA.3080608@anonymous.org.uk>
References: <20090628183111280.HTRN20969@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090628183111280.HTRN20969@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/06/2009 19:31, Leslie Rhorer wrote:
> 	I have a few questions.  Some RAID implementations will simply
> refuse to create or grow an array if all the targets are not precisely the
> same size.  Clearly this is not the case for mdadm.  Not all drives of a
> given "size" are actually precisely the same size, however, and I am using
> unpartitioned drives for my RAID systems.  What happens if I add a drive
> whose apparent physical size is a bit smaller than the device size used to
> create the array?

For RAID 4/5/6, I think it'll be refused. You have to shrink the 
filesystem, and LVM if you use it, then the array, so the used size is 
no bigger than the new drive - as you've noted, md doesn't mind if it 
doesn't use all the available space on its constituent devices. If it's 
a small reduction, as I imagine it would be, and your filesystem 
supports shrinking, it won't take long to do the the shrinks. Then 
adding the new drive will be painless. If your filesystem won't shrink - 
and some (many?) won't - I suspect you're scuppered.

It has to be that way because md can't (currently?) tell whatever's 
layered over it to change itself (though I think (guess) that to some 
extent this may change at some point in the future with some of the 
topology stuff that's been discussed here recently).

I don't know what RAID 0/1/10 would do but I imagine they'd be the same.

Cheers,

John.


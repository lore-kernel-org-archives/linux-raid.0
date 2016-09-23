From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Linux raid wiki
Date: Fri, 23 Sep 2016 19:43:10 +0100
Message-ID: <57E577BE.8080101@youngman.org.uk>
References: <57E469E0.4020005@youngman.org.uk>
 <002a01d215c0$e3f20980$abd61c80$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002a01d215c0$e3f20980$abd61c80$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: WNSDEV <pete@wnsdev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks.

My understanding of role numbers is that they are the order of the disks
in which stripes are written, so role 0 has the first stripe, role 1 the
second, etc etc.

This is *normally* irrelevant, but should the array ever get trashed,
the disks need to be listed *in* *that* *order* in a new --create statement.

Can someone - Neil? Phil? - please confirm I've understood that
correctly before I update anything ...

(and I will be posting updates to the list - anything I'm not sure of I
will be asking here to check I get it right :-)

Cheers,
Wol

On 23/09/16 18:35, WNSDEV wrote:
> Hi Wol,
> 
> Thanks for your work on the wiki... I'm sending a virtual bouquet.   I've been tracking down an issue regarding role numbers which I've posted to the list http://marc.info/?l=linux-raid&m=147439325405842&w=2.  In that process I've come across other postings that say information in the wiki is incorrect so maybe this is an opportunity to update this part of the wiki.
> 
> According to  https://raid.wiki.kernel.org/index.php/Mdstat  we find:
> 
> "The raid role numbers [#] following each device indicate its role, or function, within the raid set. Any device with "n" or higher are spare disks. 0,1,..,n-1 are for the working array. Notice that there is no device 3."
> 
> But according to the following two postings, http://www.spinics.net/lists/raid/msg44491.html and http://www.spinics.net/lists/raid/msg49766.html
> the information in the wiki about the numbers in brackets (role numbers ) is wrong.
> 
> Thanks,
> Peter Sangas
> 


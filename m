From: Christian Samsel <csamsel@gmxpro.de>
Subject: Re: Device size for linux raid5 journal?
Date: Wed, 22 Feb 2017 09:40:03 +0100
Message-ID: <3798064.0ax3I63nsd@oxygen-mobile>
References: <trinity-e6976ea9-ab41-4a2a-85ce-50b77ded8f35-1487609409044@3capp-gmx-bs16> <20170221180320.7fovqiv2yore3pog@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170221180320.7fovqiv2yore3pog@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday, 21 February 2017, 19:03:20 CET  Shaohua Li wrote:
> On Mon, Feb 20, 2017 at 05:50:09PM +0100, Christian Samsel wrote:
> > Hello raid team,
> > First of all, thanks for your work.
> > So i recently read about Linux raid5/raid6 write-cache and journaling and
> > thought about giving it a try. I'm mainly interested in the additional
> > safety provided by the journal but might want be future proof to use the
> > write cache as well.
> > I read how to create an array using a journal but i havent found the
> > slightest indication of how large the respective device/partition should
> > be. I went through the lwn article [1], the slides [2] of the respective
> > engineers at facebook and a few commit messages.
> > 
> > So my question is, let's assume i have a 6TB raid5 array (3x3TB), what
> > would a good journal device size be? I'd probably went with 4GB, as this
> > is kinda the upper bound of what hardware raid controller offer.
> Thanks for trying! Depending on write-through or write-back mode. For
> write-through mode, the size could be just several hundreds megabytes. For
> write-back mode, the size should be a little bigger, several gigabytes, but
> 4 GB should be enough.

Thanks four your response. I managed to get it running. I had a backup ready 
but as the restore would have taken a lot of time i applied the patch "[PATCH 
3/3] Add new journal to array that does not have journal" (4ddd650) to mdadm 
so i could add the journal without to have to recreate the array. That worked 
as well. I think adding the journal introduced a small write speed degregation 
but thats fine for me, as i mostly do reads and data safety is top priority.
I'm using write-through mode as of now. 

> Also I added doc about raid5-cache in
> kernel_source/Documentation/md/raid5-cache.txt recently.
I didnt saw that because i'm still running 4.9. That was helpful but the 
information regarding the size is very vague:

|In write-through mode, the cache disk isn't required to be big. Several
|hundreds megabytes are enough.
...
|Too small cache disk will make the write aggregation less efficient in this
|mode depending on the workloads. It's recommended to use a cache disk with at
|least several gigabytes size in write-back mode.

Some more information like on which factors is the optimal size dependent, 
maybe application type, system memory, array size, disk speed (i dont really 
know, just naming some candidates) and how these factors impact it, would be 
helpful. If it isnt that complex i'd be totally fine to just have it stated 
"The optimal size is X GB".

Besides that, i think a pointer to this documentation inside the mdadm manpage 
would also help. I suppose for a lot of user the documentation inside the 
kernel tree isnt really the first place to look.

Christian


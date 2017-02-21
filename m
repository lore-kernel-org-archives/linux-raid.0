From: Shaohua Li <shli@kernel.org>
Subject: Re: Device size for linux raid5 journal?
Date: Tue, 21 Feb 2017 10:03:20 -0800
Message-ID: <20170221180320.7fovqiv2yore3pog@kernel.org>
References: <trinity-e6976ea9-ab41-4a2a-85ce-50b77ded8f35-1487609409044@3capp-gmx-bs16>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <trinity-e6976ea9-ab41-4a2a-85ce-50b77ded8f35-1487609409044@3capp-gmx-bs16>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Samsel <csamsel@gmxpro.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 20, 2017 at 05:50:09PM +0100, Christian Samsel wrote:
> Hello raid team,
> First of all, thanks for your work.
> So i recently read about Linux raid5/raid6 write-cache and journaling and thought about
> giving it a try. I'm mainly interested in the additional safety provided by the journal but might
> want be future proof to use the write cache as well.
> I read how to create an array using a journal but i havent found the slightest indication of how
> large the respective device/partition should be. I went through the lwn article [1], the slides [2] of the
> respective engineers at facebook and a few commit messages.
> 
> So my question is, let's assume i have a 6TB raid5 array (3x3TB), what would a good journal device size be?
> I'd probably went with 4GB, as this is kinda the upper bound of what hardware raid controller offer. 

Thanks for trying! Depending on write-through or write-back mode. For
write-through mode, the size could be just several hundreds megabytes. For
write-back mode, the size should be a little bigger, several gigabytes, but 4
GB should be enough.

Also I added doc about raid5-cache in
kernel_source/Documentation/md/raid5-cache.txt recently.

Thanks,
Shaohua

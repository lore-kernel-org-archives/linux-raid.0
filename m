From: Christian <CvB@kruemel.org>
Subject: Re: Extending an existing RAID (10) array
Date: Sun, 07 Jul 2013 08:33:19 +0200
Message-ID: <51D90BAF.2060901@kruemel.org>
References: <987a86de2c602b7d79c3b926fdfced80@kruemel.org> <20130704092402.6f3800ec@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130704092402.6f3800ec@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04.07.2013 01:24, NeilBrown wrote:
> I think you are just talking about making the devices bigger without
> increasing the number of devices.
> This possible for RAID10 as long as it uses a 'near' or 'offset' layout.  It
> is not support for 'far' layout RAID10.

And as I just found out after some googling, growing RAID10 requires at 
least kernel 3.4rc. I have Ubuntu 12.04, which has kernel 3.2

I'm now thinking I could use a parted magic live cd to grow the array, 
and then continue using it with my current linux distribution. Am I 
right in this assumption? Or have I missed something?

Thanks, Chris

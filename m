From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Thu, 03 Feb 2005 09:06:32 -0800
Message-ID: <42025A18.3000302@zytor.com>
References: <200502031145.j13Bj1fl016074@terminus.zytor.com> <420253CD.9010505@zytor.com> <20050203165934.GU7628@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050203165934.GU7628@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree wrote:
> On 2005-02-03T08:39:41, "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> 
>>Yes, right now there is no RAID5->RAID6 conversion tool that I know of.
> 
> Hm. One of the checksums is identical, as is the disk layout of the
> data, no?
> 

No, the layout is different.

	-hpa

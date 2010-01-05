From: Michal Soltys <soltys@ziu.info>
Subject: Re: Alignment of RAID on specific boundary
Date: Tue, 05 Jan 2010 08:50:21 +0100
Message-ID: <4B42EF3D.9000507@ziu.info>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com> <4877c76c1001042257h49103054t977de11410eb65c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1001042257h49103054t977de11410eb65c6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans wrote:
> 
> It starts the LVM2 header after 0x3000 bytes (64K chunk size); I'd
> hope to see it around 0x10000.
> 
> It looks like the data isn't padded up to the desired offset.
> 
> I agree, it would be useful to have an option to specify the offset of
> the first data chunk.


Regarding lvm, you can use --dataalignment and --metadatasize for that purpose. 
Recent lvm versions, when creating directly on md raid (and assuming recent kernel), 
should align themselves automatically:

http://www.redhat.com/archives/linux-lvm/2009-September/msg00092.html


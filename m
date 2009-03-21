From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
Date: Sat, 21 Mar 2009 13:19:01 +0300
Message-ID: <49C4BF15.5050502@emcraft.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com> <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com> <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com> <49C45159.8020503@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49C45159.8020503@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Hi H. Peter,

H. Peter Anvin wrote:
> Ilya Yanok wrote:
>   
>> async_gen_syndrome() takes element of GF^n(256) and returns result of
>> scalar multiplication of it with constant ({01}, {02}, {02}^2, ...,
>> {02}^n) vector.
>>     
>
> For any n (which would mean any GF field)?  In that case, that is
> generic scalar-vector multiplication...
>   

Ok. I think I got it. Vectors are things that depend on position inside
buffer and scalars are things that don't, am I right? In that sense we
don't have any vector-vector multiplication. Both async_gen_syndrome()
and async_pq() use constant coefficients. So I don't really understand
the problem here.

Regards, Ilya.


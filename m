From: antlists <antlists@youngman.org.uk>
Subject: =?UTF-8?Q?Re=3a_=5bPATCH_2/2=5d_restripe=3a_fix_ignoring_return_val?=
 =?UTF-8?B?dWUgb2Yg4oCYcmVhZOKAmQ==?=
Date: Tue, 19 May 2020 11:14:56 +0100
Message-ID: <03f9adb1-4b1f-eba3-b376-981c06ae1e5a@youngman.org.uk>
References: <20200515134026.8084-1-guoqing.jiang@cloud.ionos.com>
 <20200515134026.8084-3-guoqing.jiang@cloud.ionos.com>
 <4a888cbe-636b-b3a7-f669-8897753430d0@trained-monkey.org>
 <607932ff-0e76-9eca-1fdb-ca26428d8717@cloud.ionos.com>
 <01676778-bfc2-46d4-112b-ee16ef4cbcc1@trained-monkey.org>
 <6bd3cb34-1339-9e1b-1f57-07ef62a70818@cloud.ionos.com>
 <8671d1fb-1b59-cebf-e1f1-09490856e02b@trained-monkey.org>
 <b8df31b2-f9cf-4d4d-1846-77304b55b3ea@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b8df31b2-f9cf-4d4d-1846-77304b55b3ea@cloud.ionos.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Jes Sorensen <jes@trained-monkey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/05/2020 22:37, Guoqing Jiang wrote:
>> That should work, however you really should check the return value of
>> lseek as well, while looking at this.
> 
> Okay, though I did not get complain about it =-O. Anyway, will send v3.

Just for info - I'm currently building my new system, which means my old 
system will become a raid testbed. And I'm playing with dm-integrity, 
which I believe returns an integrity error not a read error when things 
go wrong.

So yes, if errors aren't handled correctly I'm quite likely to find 
myself falling over them ...

Cheers,
Wol

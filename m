Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEADC21CFF6;
	Wed, 21 May 2025 09:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747818059; cv=none; b=Mh9je+1Axd/1RiEC3Y6XisPU0EX1Jz3SADAueMUOzjdK/XiXSpwth9XeICYtrJmf3XXPk7IjruInQkfaCndTXqKkKvLBBBq0bFbHOp9D6wBwL2m18GETuGJ36WHIjF0UJZ+SrC29SGzHLvIgjZWBBmvzvc3y+1flXM1nlwPK5ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747818059; c=relaxed/simple;
	bh=+ZZ0k269drvwAZCcS2mfHtyZXHbxhAoULDCs+DKm0zw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VShdOZmqvRkF8CJD2WTFR6U+aoPTurBFoHOZNAZOfsHIcbVT6iSvyfP3/2bkEnKEGvX/6quxJbVUH9O83lLjnmNkc6qANSW1Gk0JnFwPhKWCRNPLsP4e0uhXCFXG7FiUyxYLwaaFOGP4zJt0rHvXrbirfI4GmWfUilYVw3Dfj98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id CE98B43150;
	Wed, 21 May 2025 09:00:44 +0000 (UTC)
Message-ID: <d0798e3c-953a-4f0e-a7e2-d59ce1211160@ghiti.fr>
Date: Wed, 21 May 2025 11:00:44 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
From: Alexandre Ghiti <alex@ghiti.fr>
To: Chunyan Zhang <zhang.lyra@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>
Cc: zhangchunyan@iscas.ac.cn, Paul Walmsley <paul.walmsley@sifive.com>,
 aou@eecs.berkeley.edu, Charlie Jenkins <charlie@rivosinc.com>,
 song@kernel.org, yukuai3@huawei.com, linux-riscv@lists.infradead.org,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250305083707.74218-1-zhangchunyan@iscas.ac.cn>
 <mhng-63c49bc7-0f86-47f7-bc41-0186f77b9d6f@palmer-ri-x1c9>
 <CAAfSe-vD_37uihLjGwOqQKnyKJaJ36OwxDeocMOhK4s6-cpzAA@mail.gmail.com>
 <da18536c-cb40-42f4-a097-2e8a03780dc9@ghiti.fr>
Content-Language: en-US
In-Reply-To: <da18536c-cb40-42f4-a097-2e8a03780dc9@ghiti.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgddvieeiucdltddurdegfedvrddttddmucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuhffvvehfjggtgfesthekredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpeeltdffkeegffelheekvdfgleelfeffteejgeeuffegieelgfdvhfetteeujeegkeenucffohhmrghinhepihhnfhhrrgguvggrugdrohhrghenucfkphepvddttddumeekiedumeeffeekvdemvghfledtmegtugdvgeemlegsleehmeefudejsgemtgefudgrnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddttddumeekiedumeeffeekvdemvghfledtmegtugdvgeemlegsleehmeefudejsgemtgefudgrpdhhvghloheplgfkrfggieemvddttddumeekiedumeeffeekvdemvghfledtmegtugdvgeemlegsleehmeefudejsgemtgefudgrngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopeduuddprhgtphhtthhopeiihhgrnhhgrdhlhihrrgesghhmrghilhdrtghomhdprhgtphhtthhopehprghlmhgvrhesuggrsggsvghlthdrtghom
 hdprhgtphhtthhopeiihhgrnhhgtghhuhhnhigrnhesihhstggrshdrrggtrdgtnhdprhgtphhtthhopehprghulhdrfigrlhhmshhlvgihsehsihhfihhvvgdrtghomhdprhgtphhtthhopegrohhusegvvggtshdrsggvrhhkvghlvgihrdgvughupdhrtghpthhtoheptghhrghrlhhivgesrhhivhhoshhinhgtrdgtohhmpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeihuhhkuhgrihefsehhuhgrfigvihdrtghomh
X-GND-Sasl: alex@ghiti.fr

On 5/13/25 13:39, Alexandre Ghiti wrote:
> Hi Chunyan,
>
> On 08/05/2025 09:14, Chunyan Zhang wrote:
>> Hi Palmer,
>>
>> On Mon, 31 Mar 2025 at 23:55, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>> On Wed, 05 Mar 2025 00:37:06 PST (-0800), zhangchunyan@iscas.ac.cn 
>>> wrote:
>>>> The assembly is originally based on the ARM NEON and int.uc, but uses
>>>> RISC-V vector instructions to implement the RAID6 syndrome and
>>>> recovery calculations.
>>>>
>>>> The functions are tested on QEMU running with the option "-icount 
>>>> shift=0":
>>> Does anyone have hardware benchmarks for this?  There's a lot more code
>>> here than the other targets have.  If all that unrolling is 
>>> necessary for
>>> performance on real hardware then it seems fine to me, but just having
>>> it for QEMU doesn't really tell us much.
>> I made tests on Banana Pi BPI-F3 and Canaan K230.
>>
>> BPI-F3 is designed with SpacemiT K1 8-core RISC-V chip, the test
>> result on BPI-F3 was:
>>
>>    raid6: rvvx1    gen()  2916 MB/s
>>    raid6: rvvx2    gen()  2986 MB/s
>>    raid6: rvvx4    gen()  2975 MB/s
>>    raid6: rvvx8    gen()  2763 MB/s
>>    raid6: int64x8  gen()  1571 MB/s
>>    raid6: int64x4  gen()  1741 MB/s
>>    raid6: int64x2  gen()  1639 MB/s
>>    raid6: int64x1  gen()  1394 MB/s
>>    raid6: using algorithm rvvx2 gen() 2986 MB/s
>>    raid6: .... xor() 2 MB/s, rmw enabled
>>    raid6: using rvv recovery algorithm


So I'm playing with my new BananaPi and I got the following numbers:

[    0.628134] raid6: int64x8  gen()  1074 MB/s
[    0.696263] raid6: int64x4  gen()  1574 MB/s
[    0.764383] raid6: int64x2  gen()  1677 MB/s
[    0.832504] raid6: int64x1  gen()  1387 MB/s
[    0.833824] raid6: using algorithm int64x2 gen() 1677 MB/s
[    0.907378] raid6: .... xor() 829 MB/s, rmw enabled
[    0.909301] raid6: using intx1 recovery algorithm

So I realize that you provided the numbers I asked for...Sorry about 
that. That's a very nice improvement, well done.

I'll add your patch as-is for 6.16.

Thanks again,

Alex


>>
>> The K230 uses the XuanTie C908 dual-core processor, with the larger
>> core C908 featuring the RVV1.0 extension, the test result on K230 was:
>>
>>    raid6: rvvx1    gen()  1556 MB/s
>>    raid6: rvvx2    gen()  1576 MB/s
>>    raid6: rvvx4    gen()  1590 MB/s
>>    raid6: rvvx8    gen()  1491 MB/s
>>    raid6: int64x8  gen()  1142 MB/s
>>    raid6: int64x4  gen()  1628 MB/s
>>    raid6: int64x2  gen()  1651 MB/s
>>    raid6: int64x1  gen()  1391 MB/s
>>    raid6: using algorithm int64x2 gen() 1651 MB/s
>>    raid6: .... xor() 879 MB/s, rmw enabled
>>    raid6: using rvv recovery algorithm
>>
>> We can see the fastest unrolling algorithm was rvvx2 on BPI-F3 and
>> rvvx4 on K230 compared with other rvv algorithms.
>>
>> I have only these two RVV boards for now, so no more testing data on
>> more different systems, I'm not sure if rvv8 will be needed on some
>> hardware or some other system environments.
>
>
> Can we have a comparison before and after the use of your patch?
>
> In addition, how do you check the correctness of your implementation?
>
> I'll add whatever numbers you provide to the commit log and merge your 
> patch for 6.16.
>
> Thanks a lot,
>
> Alex
>
>
>>
>> Thanks,
>> Chunyan
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

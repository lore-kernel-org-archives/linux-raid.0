From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [patch 2/3 v3] raid1: read balance chooses idlest disk for SSD
Date: Mon, 2 Jul 2012 01:31:26 -0300
Message-ID: <CABYL=Tresfnb+9369_Y4_PrF0-RY3FjgRZ6e_N8d5iPrTRVr-Q@mail.gmail.com>
References: <20120702010840.197370335@kernel.org>
	<20120702011031.890864816@kernel.org>
	<CABYL=TpD7D0ec40fz6uo4LCPAKuxtkx5rD3JXfWTtuEYp3NLYQ@mail.gmail.com>
	<20120702030245.GB29770@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702030245.GB29770@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

for SSD without inteligent parts (cache and queue) i think this could
works nice... (at least in theory)
for USB sticks and microsd cards may work too...


2012/7/2 Shaohua Li <shli@kernel.org>:
> On Sun, Jul 01, 2012 at 11:13:42PM -0300, Roberto Spadim wrote:
>> nice =) very very nice =)
>> maybe to get better than this... select the disk with min(pending time)
>>
>> time could be estimated with something like:
>> (distance * time/distance unit) + (blocks to read/write * time to
>> read/write 1 block) + (non sequencial penalty time)
>
> I didn't think there is way to measure request time. Disks support NCQ, they
> can dispatch several requests at one time and finish them almost at the same
> time. I used to measure this time (to make CFQ ioscheduler self tune), but
> failed.
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial

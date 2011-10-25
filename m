From: Michal Soltys <soltys@ziu.info>
Subject: Re: mdadm r/w operations without TEMP_FAILURE_RETRY()
Date: Tue, 25 Oct 2011 19:29:52 +0200
Message-ID: <4EA6F210.7040701@ziu.info>
References: <2AC2FDB9F3686F48962B2B65E2040CCC3D155FA0@irsmsx503.ger.corp.intel.com> <20111018203016.4536708f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111018203016.4536708f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Orlowski, Lukasz" <lukasz.orlowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11-10-18 11:30, NeilBrown wrote:
> On Tue, 18 Oct 2011 10:16:41 +0100 "Orlowski, Lukasz"
> <lukasz.orlowski@intel.com>  wrote:
>
>> Hi,
>>
>> I was going through mdadm code and got to realize that r/w
>> operations are invoked without TEMP_FAILURE_RETRY() macro, which
>> protects from unexpected operation termination, case SIGINT is
>> thrown. According to my knowledge its POSIX best-practice to call
>> the r/w operations within that macro, lest some sporadic unexpected
>> behaviors occur.
>>
>> Any particular reason for not using it?
>
> I've never heard of TEMP_FAILURE_RETRY.
>
> And having looked in to it I would certainly try to avoid using it.
>

As this grabbed my attention ..

that macro is just a shortcut to something along the:

do {
	ret = read/write/etc.( ... );
} while (ret < 0 && errno == EINTR);

which has always been the proper way to handle such situations 
(recollecting Stevens books, glibc reference manual, or any other solid 
source). Why avoid using it ? Costs nothing, and guarantees we won't run 
into some corner case.

> If the SA_RESTART flag is set with sigaction() then it should be
> totally unnecessary.
>

signals(7) has pretty large list of when it can or cannot happen, and
when it will always happen regardless of SA_RESTART. And it would be 
quite different list when other unix vendors are considered (which 
doesn't of course apply to mdadm case, it being only linux specific). 
There're also not ignorable stop signals (and under some cases they will 
end with EINTR as well).

And it's not only SIGINT (as the original mail could suggest), any not 
ignored signal can cause it.

From: Guoqing Jiang <jgq516@gmail.com>
Subject: Re: [PATCH 3/3] MD: hold mddev lock for md-cluster receive thread
Date: Wed, 3 Aug 2016 11:42:52 +0800
Message-ID: <57A1683C.5020807@gmail.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
 <7763e508fb97d44bd61e826912055617b8be2c2d.1469922791.git.shli@fb.com>
 <579F0AA3.5090806@suse.com> <20160801214522.GA129828@kernel.org>
 <57A06D69.2040703@suse.com> <87shumpvbd.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87shumpvbd.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/03/2016 08:09 AM, NeilBrown wrote:
> On Tue, Aug 02 2016, Guoqing Jiang wrote:
>>> Does it work if we move the mddev lock to
>>> process_recvd_msg?
>> I tried that, but It still have lock issue, eg, when node B and C have
>> status
>> as "resync=PENDING", then try to stop the resyncing array in node A.
>>
> Maybe the reconfig_mutex locking needs to go down in
> process_suspend_info() ?? That is the only part that calls quiesce.

Yes, but with this change, I still have lock issue for below steps:
1. create a resyning array in nodeA
2. Assemble the array in node B and nodeC

I can see A can't continue perform resync while C can't assemble
array successfully.

Thanks,
Guoqing


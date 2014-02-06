From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 45/51] md, raid5: Fix CPU hotplug callback registration
Date: Thu, 06 Feb 2014 15:35:22 +0530
Message-ID: <52F35E62.2060003@linux.vnet.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205221244.19080.70910.stgit@srivatsabhat.in.ibm.com> <20140206121151.0cbdbaa1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140206121151.0cbdbaa1@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, oleg@redhat.com
Cc: paulus@samba.org, rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org, mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

On 02/06/2014 06:41 AM, NeilBrown wrote:
> On Thu, 06 Feb 2014 03:42:45 +0530 "Srivatsa S. Bhat"
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> From: Oleg Nesterov <oleg@redhat.com>
>>
>> Subsystems that want to register CPU hotplug callbacks, as well as perform
>> initialization for the CPUs that are already online, often do it as shown
>> below:
>>
>> 	get_online_cpus();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	put_online_cpus();
>>
>> This is wrong, since it is prone to ABBA deadlocks involving the
>> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
>> with CPU hotplug operations).
>>
>> Interestingly, the raid5 code can actually prevent double initialization and
>> hence can use the following simplified form of callback registration:
>>
>> 	register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	get_online_cpus();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	put_online_cpus();
>>
>> A hotplug operation that occurs between registering the notifier and calling
>> get_online_cpus(), won't disrupt anything, because the code takes care to
>> perform the memory allocations only once.
>>
>> So reorganize the code in raid5 this way to fix the deadlock with callback
>> registration.
>>
>> Cc: Neil Brown <neilb@suse.de>
>> Cc: linux-raid@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> [Srivatsa: Fixed the unregister_cpu_notifier() deadlock, added the
>> free_scratch_buffer() helper to condense code further and wrote the changelog.]
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
[...]
> 
> 
> Looks good, thanks.
> Shall I wait for a signed-of-by from Oleg, then queue it through my md tree?
> 

Sure, that sounds great, since this patch doesn't have any dependency.
Thanks a lot!

Oleg, it would be great if you could kindly add your S-O-B to this patch.
Thanks!

Regards,
Srivatsa S. Bhat

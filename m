From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 45/51] md, raid5: Fix CPU hotplug callback registration
Date: Thu, 6 Feb 2014 19:43:23 +0100
Message-ID: <20140206184323.GB31410@redhat.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205221244.19080.70910.stgit@srivatsabhat.in.ibm.com> <20140206121151.0cbdbaa1@notabene.brown> <52F35E62.2060003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52F35E62.2060003@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: NeilBrown <neilb@suse.de>, paulus@samba.org, rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org, mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

On 02/06, Srivatsa S. Bhat wrote:
>
> On 02/06/2014 06:41 AM, NeilBrown wrote:
> > Shall I wait for a signed-of-by from Oleg, then queue it through my md tree?
> >
>
> Sure, that sounds great, since this patch doesn't have any dependency.
> Thanks a lot!
>
> Oleg, it would be great if you could kindly add your S-O-B to this patch.
> Thanks!

Thanks Neil and Srivatsa,

Sure, feel free to add

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

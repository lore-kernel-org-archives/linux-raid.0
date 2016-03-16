From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: Cleanup cpu hotplug notifier
Date: Wed, 16 Mar 2016 10:11:35 -0700
Message-ID: <20160316171135.GA80081@kernel.org>
References: <1458116723-66984-1-git-send-email-anna-maria@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458116723-66984-1-git-send-email-anna-maria@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Anna-Maria Gleixner <anna-maria@linutronix.de>
Cc: linux-kernel@vger.kernel.org, rt@linutronix.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 16, 2016 at 09:25:23AM +0100, Anna-Maria Gleixner wrote:
> The raid456_cpu_notify() hotplug callback lacks handling of the
> CPU_UP_CANCELED case. That means if CPU_UP_PREPARE fails, the scratch
> buffer is leaked.
> 
> Add handling for CPU_UP_CANCELED[_FROZEN] hotplug notifier transitions
> to free the scratch buffer.
> 
> CC: Shaohua Li <shli@kernel.org>
> CC: linux-raid@vger.kernel.org
> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>

Applied, thanks!

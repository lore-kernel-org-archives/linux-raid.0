From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH v3] udev rules: introduce rules for cluster-md to confirm
 device
Date: Wed, 2 Aug 2017 22:50:41 -0400
Message-ID: <22914.36737.548270.182436@quad.stoffel.home>
References: <20170801031504.8452-1-gqjiang@suse.com>
        <20170802020541.3412-1-gqjiang@suse.com>
        <22914.32725.983017.495207@quad.stoffel.home>
        <59828314.3050602@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59828314.3050602@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.com
List-Id: linux-raid.ids

>>>>> "Guoqing" == Guoqing Jiang <gqjiang@suse.com> writes:

Guoqing> On 08/03/2017 09:43 AM, John Stoffel wrote:
>>>>>>> "Guoqing" == Guoqing Jiang <gqjiang@suse.com> writes:
Guoqing> For cluster scenario, add device is different with native raid.
Guoqing> When a node issues adds a device, then the node will broadcast
Guoqing> a message with UUID to other nodes in the cluster. If receiving
Guoqing> node can find the device with the specific UUID, it must confirm
Guoqing> the device, otherwise reports it is missing.
>> 
Guoqing> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Guoqing> ---
Guoqing> Makefile                               |  6 ++++--
Guoqing> udev-md-clustered-confirm-device.rules | 21 +++++++++++++++++++++
Guoqing> 2 files changed, 25 insertions(+), 2 deletions(-)
Guoqing> create mode 100644 udev-md-clustered-confirm-device.rules
>> 
Guoqing> diff --git a/Makefile b/Makefile
Guoqing> index 021d3ad..0977f27 100644
Guoqing> --- a/Makefile
Guoqing> +++ b/Makefile
Guoqing> @@ -256,8 +256,10 @@ install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
Guoqing> $(INSTALL) -D -m 644 md.4 $(DESTDIR)$(MAN4DIR)/md.4
Guoqing> $(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
>> 
Guoqing> -install-udev: udev-md-raid-arrays.rules udev-md-raid-assembly.rules udev-md-raid-creating.rules
Guoqing> -	@for file in 01-md-raid-creating.rules 63-md-raid-arrays.rules 64-md-raid-assembly.rules ; \
Guoqing> +install-udev: udev-md-raid-arrays.rules udev-md-raid-assembly.rules udev-md-raid-creating.rules \
Guoqing> +		udev-md-clustered-confirm-device.rules
>> 
>> 
>> You have udev-md-clustered-.... here, but down below you use
>> clustermd-end in your names.  Which I find slightly annoying because
>> they're different.  Just me being annoying here.  :-)  I didn't check
>> if the other raid rules have this issue as well.
>> 

Guoqing> Well, I named it as "udev-md-clustered-*" to align with the
Guoqing> name of existed udev rules, it also means the array is
Guoqing> clustered. And clustermd is a convenient/short name to use.

I think mdcluster is better than clustermd, but that's only because
it's the same order as udev-md-clustered-* but we're both just
bike shedding here.  :-)  

Guoqing> But not a big deal, I am open to the name if you have better
Guoqing> idea, :-) .

Not really.  Appreciate your nice reply to my semi-inane comment.


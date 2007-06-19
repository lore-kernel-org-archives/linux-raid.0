From: David Greaves <david@dgreaves.com>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after
	hibernate/resume
Date: Tue, 19 Jun 2007 16:31:45 +0100
Message-ID: <4677F6E1.50108@dgreaves.com>
References: <46744065.6060605@dgreaves.com> <4676D97E.4000403@dgreaves.com>
	<4677A0C7.4000306@dgreaves.com> <200706191321.07278.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <200706191321.07278.rjw@sisk.pl>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/linux-pm>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>
List-Id: linux-raid.ids

Rafael J. Wysocki wrote:
>> This is on 2.6.22-rc5
> 
> Is the Tejun's patch
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/30-block-always-requeue-nonfs-requests-at-the-front.patch
> 
> applied on top of that?

2.6.22-rc5 includes it.

(but, when I was testing rc4, I did apply this patch)

David

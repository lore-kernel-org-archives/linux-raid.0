From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: reboot during reshape: superblock incorrect, cannot assemble
Date: Tue, 17 Aug 2010 22:27:32 +0100
Message-ID: <4C6AFEC4.6040707@anonymous.org.uk>
References: <AANLkTikX5+MCicoYShS_=MqpuCr0CMgS1S2n97-k_Aoy@mail.gmail.com>	<alpine.DEB.1.10.1008172222500.8562@uplift.swm.pp.se>	<AANLkTim-K8bZSxx==cSy9rsCRxpc50HGvaRT6nFzf+UN@mail.gmail.com> <AANLkTik-7WHQQit-RovNYJWeMAaqoBDJvVfRcHqgZxBG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik-7WHQQit-RovNYJWeMAaqoBDJvVfRcHqgZxBG@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joris <joris@v5.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/08/2010 22:19, Joris wrote:
> Now to teach grub about version 0.91 and I'm back in business.

Version 0.91 means 0.90 + reshaping, mdadm that support reshaping mark 
0.90 arrays that are undergoing reshaping with version 0.91 so older 
mdadm that don't do reshaping don't try to start it. If your reshape is 
now restarted, mdadm will change the metadata version back to 0.90 when 
the reshape is finished.

Cheers,

John.

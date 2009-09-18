From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Fri, 18 Sep 2009 18:44:00 +0100
Message-ID: <4AB3C6E0.7010908@anonymous.org.uk>
References: <h8nbt5$n8p$1@ger.gmane.org>	 <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>	 <h8nfoe$n8p$3@ger.gmane.org>	 <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>	 <h8nreb$n8p$4@ger.gmane.org> <87ws3z5iro.fsf@frosties.localdomain>	 <1253106813.17888.9.camel@localhost>	 <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com> <1253273738.9662.636.camel@kiste>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253273738.9662.636.camel@kiste>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/09/2009 12:35, Matthias Urlichs wrote:
[...]
> If you run a check on a degraded array and the check runs into errors it
> can't recover from, I assume that the disk will get kicked off and
> you'll have a nonfunctional array instead.

No, I don't think so - at least with RAID-1, md doesn't drop the array 
on errors on the one remaining functional disc, on the grounds that some 
data is better than none, but I don't know whether the array gets 
switched to read-only or what the situation is with other RAID levels.

Cheers,

John.

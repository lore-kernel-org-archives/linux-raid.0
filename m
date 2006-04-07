From: Chris Osicki <osk@admin.swisscom-mobile.ch>
Subject: Re: accessing mirrired lvm on shared storage
Date: Fri, 7 Apr 2006 13:46:36 +0200
Message-ID: <20060407134636.2bce1917@mwdsp001>
References: <44355BC9.4020608@mailing.kaufland-informationssysteme.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44355BC9.4020608@mailing.kaufland-informationssysteme.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Matthias

I have currently four clusters which mirror shared storage. I've
always pay great attention not to have an array active on both
cluster nodes. I can imagine data corruption would happen soon or
late.
Unfortunately md lacks the ability to mark an array as
used/busy/you_name_it. Sometime ago I asked on this list for such an
enhancement (see thread with subject "Question: array locking,
possible"). Although I managed (with great help from few people on 
this list) to attract Neil's attention, I couldn't fine enough
arguments to convince him to put this topic on hist TO-DO list.
Neil, you see the constantly growing number of potential users of this
feature? ;-)


Regards,
Chris

PS Matthias, just curious, you don't have FC failover, right?

On Thu, 06 Apr 2006 20:19:53 +0200
Matthias Eble 	<matthias.eble@mailing.kaufland-informationssysteme.com> wrote:

> 
> Hi all,
> 
> I've got an extended setup whith two Systems, each with two FC cards. 
> Every card is connected to a seperate disk array (so one system accesses 
> two arrays). The other node has access to the same two arrays (standby).
> 
> The active server mirrors the data (4 LUNs) between the two arrays via 
> md. On top is a LVM physical volume. The other system is meant to be 
> booted but not acessing the VGs.
> 
> My question is, if it is possible to let both systems set up the md 
> mirror without corrupting the data? Is there any data written even when 
> the VGs are not taken active? I think I remember that LVM refuses to 
> activate volumegroups which are active on another system, right?
> This would save me from caring about IO fencing.
> 
> thanks for your help in advance..
> matthias
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

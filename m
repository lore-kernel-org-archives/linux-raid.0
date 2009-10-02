From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Fri, 02 Oct 2009 09:55:22 -0400
Message-ID: <4AC6064A.5020203@tmr.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <h8nfoe$n8p$3@ger.gmane.org> 	<alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev> 	<h8nreb$n8p$4@ger.gmane.org> <87ws3z5iro.fsf@frosties.localdomain> 	<1253106813.17888.9.camel@localhost> <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com> 	<1253273738.9662.636.camel@kiste> <4AB3C6E0.7010908@anonymous.org.uk> 	<87f94c370909181102y25ee0ba9o833ea2f9c09ff8d7@mail.gmail.com> <70ed7c3e0909181313p10abefe6u72329b6e8932cd2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909181313p10abefe6u72329b6e8932cd2b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Majed B. wrote:
> Greg,
>
> You don't really need to use hdparm. You can use dd to overwrite the
> bad sectors with zeros which forces the disk to remap the sector.
>   

 From the description of the problem, I would expect the md code to have 
rewritten the sector, and the problem is that the failed write isn't 
detected or somehow the write doesn't cause a relocate. That's my 
reading of the previous discussion, disk firmware is crap.

Newegg.Com had TB drives on sale for about $65 or so, hard to justify 
the time to live with crap, not to mention that the same grotty firmware 
which isn't getting the bad block remapped may be return bad data 
without warning. That would bother me.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.


From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Why does one get mismatches?
Date: Fri, 22 Jan 2010 08:22:03 -0800 (PST)
Message-ID: <141903.28627.qm@web51308.mail.re2.yahoo.com>
References: <hj73e0$anm$1@ger.gmane.org>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hj73e0$anm$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Brett Russ <bruss@netezza.com>
List-Id: linux-raid.ids

<SNIP>
> 
> Note that if your md device is not in a read-only mode that
> the member states may be changing underneath you as you run
> the above command. Therefore, you should either stop the
> device then run the commands, or at least have the device in
> a read-only mode first.
> 
> -BR
> 

I have just tried this - i umounted all LV and then deactivated the VG. I set to read-only but now any attempt to echo check > sync_action results in

'write error: device or resource busy'

any clues/


      

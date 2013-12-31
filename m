From: Wolfgang Denk <wd@denx.de>
Subject: Re: The chunk size paradox
Date: Tue, 31 Dec 2013 01:01:32 +0100
Message-ID: <20131231000132.879A7381435@gemini.denx.de>
References: <52C1C01A.7010407@ubuntu.com> <21186.996.238486.690328@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <21186.996.238486.690328@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Peter,

In message <21186.996.238486.690328@tree.ty.sabi.co.uk> you wrote:
> 
> Therefore a larger chunk size increases the amount of data that
> can be fetched on each device without waiting for the other
> device to get to the desires angular position. It has of course
> the advnatage that you mention, but also the advantage that
> random IO might be improved.

Hm... does it make sense to discuss any of this without considering
the actual work load of the storage system?

For example, we have some RAID 6 arrays that store mostly source code
and the resulting object files when compiling that code.  In this
environment, we have the following distribution of file sizes:

	65% 	are smaller than 4 kB
	80% 	are smaller than 8 kB
	90% 	are smaller than 16 kB
	96% 	are smaller than 32 kB
	98.4% 	are smaller than 64 kB 

It appears to me, that your argumentation is valid only for large (or
rather huge), strictly sequential file accesses only.  Random acces to
a large number of small files like in the environment shown above will
need pretty much different settings for optimal performance.

I think we should not conceal such dependencies.  There is no "one
size fits all" solution.

Just my $ 0.02.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Man is the best computer we can put aboard a spacecraft ...  and  the
only one that can be mass produced with unskilled labor.
                                                  - Wernher von Braun

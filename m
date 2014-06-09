From: Wolfgang Denk <wd@denx.de>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Mon, 09 Jun 2014 21:37:23 +0200
Message-ID: <20140609193723.79F1B3809B0@gemini.denx.de>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>, Roman Mamedov <rm@romanrm.net>, Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids

Dear Chris,

In message <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> you wrote:
>
> # dd if=/dev/zero of=/dev/sda seek=430234064 count=8 oflag=direct
> 8+0 records in
> 8+0 records out
> 4096 bytes (4.1 kB) copied, 3.73824 s, 1.1 kB/s

This has been pointed out before - if this is a 4k sector drive, then
you should really write in units of 4 k, not 8 x 512 bytes as you do
here.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"Security is mostly a superstition. It does not  exist  in  nature...
Life is either a daring adventure or nothing."         - Helen Keller

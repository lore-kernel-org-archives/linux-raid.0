From: maurice <mhilarius@gmail.com>
Subject: Re: SSD - TRIM command
Date: Tue, 08 Feb 2011 14:18:28 -0700
Message-ID: <4D51B324.5060901@gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>	<4D517F4F.4060003@gmail.com>	<AANLkTi=sgTjGMvNiZB2aqxpe8-z7V0bUks84+fMxCAoY@mail.gmail.com>	<AANLkTik5SumqyTN5LZVntna8nunvPe7v38TSFf9eCfcU@mail.gmail.com> <AANLkTikrKCh3X7aLGqt8hDi2SK4LuZUykVRY2Mo4Nvm4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikrKCh3X7aLGqt8hDi2SK4LuZUykVRY2Mo4Nvm4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/8/2011 1:50 PM, Roberto Spadim wrote:
> =] now the right answer :)
> question: maybe in future... could we make trim compatible with md?
>
I  hope that future is "real soon now"
MLC SSD is now starting to appear in the "Enterprise space.
Companies like Pliant have released products for that.
Typical SAN RAID controllers have specific performance limits which can 
be saturated with a not very large number of SSDs.
To get higher IOs we need a more powerful RAID engine
A typical 48 core, 128GB RAM box using AMD CPUs and 4 SAS HBAs to disk 
JBD cases can be a ridiculously power RAID engine for a
reasonable cost ( at least reasonable compered to NetApp, EMC, Hitachi 
SANs, etc) with a large number of devices.

BUT: To use SSDs in the design we need mdadm to be more SSD friendly.


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/

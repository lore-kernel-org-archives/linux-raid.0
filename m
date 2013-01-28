From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 23:59:35 +0100
Message-ID: <20130128225935.B8E2B20004B@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris,

In message <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com> you wrote:
> 
> Yes, it sounds reproducible on more than one array, more than one HBA. Is it also more than one computer also, Wolfgang?

Correct, these are 3 different machines.

> I think regression is going to be needed to find it. Hopefully the
> problem is restricted to parity computation and data chunks aren't
> affected; however if a URE occurs in a data chunk, it could be
> reconstructed incorrectly from bad parity so it's obviously still a
> big problem.

My gut feeling is that the data are still OK, but I have to admit that
I inspected only a small fraction of the files, and I would like to
avoid restoring the data from backup tapes to another system as long
as possible.  So it indeed appears to me as if we had a sotware issue,
computing incorrect parity data.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"Consistency requires you to be as ignorant today as you were a  year
ago."                                              - Bernard Berenson

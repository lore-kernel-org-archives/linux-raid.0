From: Wolfgang Denk <wd@denx.de>
Subject: resize a 'far' RAID10 ?
Date: Tue, 24 Mar 2015 14:48:21 +0100
Message-ID: <20150324134821.74A4A38096B@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I am aware that it has been impossible to resize a 'far' RAID10; at
least for v3.4 or so - see for example [1]

Has this restriction been listed in the meantime?

If not: I have swapped disk drives for larger models and would like to
make use of the additional size.  Is creating another RAID on the free
space the only available option?

Thanks in advance.

[1] http://www.spinics.net/lists/raid/msg38491.html

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"Everything should be made as simple as possible, but not simpler."
                                                    - Albert Einstein

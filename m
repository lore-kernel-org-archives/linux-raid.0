From: Wolfgang Denk <wd@denx.de>
Subject: Re: Automatically start two-level mdadm RAID arrays (i.e. RAID 60) on boot?
Date: Fri, 16 Feb 2018 12:00:04 +0100
Message-ID: <20180216110004.7DBF9240159@gemini.denx.de>
References: <CAA43vkUG8LrMUjazeYFtGVKVuTvrYRPe-UcPb21r=xeYpctpmg@mail.gmail.com> <20180216020217.2a9c7690@natsu> <4ebbb6bf-70a9-fb85-1b9f-82850a187e47@turmel.org> <39e0bf6b-4280-590c-9d96-013c70d4e0a4@fnarfbargle.com> <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sean Caron <scaron@umich.edu>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Sean,

In message <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com> you wrote:
>
> As it is now, we just populate /etc/mdadm/mdadm.conf ARRAY lines with
> the output of mdadm --examine --scan after building all the RAID 6
> strings and the top level RAID 0 container. This gives the result
> where the RAID 0 containers are the last lines in the file, after all
> the RAID 6 strings. For example, on a machine with RAID 6 strings
> md0...4 and RAID 0 string md5 (containing md0...md4), we have
> mdadm.conf contents like:

Just in case it is not clear (you didn't mention you did): after
generating /etc/mdadm/mdadm.conf you _must_ also rebuild the
initramfs image for your running kernel, so the new mdadm.conf gets
included there, where it is actually needed.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I don't know if it's what you want, but it's what you get.  :-)
                      - Larry Wall in <10502@jpl-devvax.JPL.NASA.GOV>

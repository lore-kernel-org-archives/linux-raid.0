From: Wolfgang Denk <wd@denx.de>
Subject: Re: Disk Monitoring
Date: Wed, 28 Jun 2017 15:19:17 +0200
Message-ID: <20170628131917.BF1911235B6@gemini.denx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
        boundary="==_Exmh_1498655662_67180"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multipart MIME message.

--==_Exmh_1498655662_67180
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
In-reply-to: <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com>
References: <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com>
Comments: In-reply-to Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
   message dated "Wed, 28 Jun 2017 12:25:55 +0200."

Dear Gandalf,

In message <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com> you wrote:
> 
> 1) all raid controllers have proactive monitoring features, like
> patrol read, consistency check and (more or less) some SMART
> integration.
> Any counterpart in mdadm?

As Wol already pointed out, you should use  smaartctl  to monitor
the state of the disk drives, ideally on a regular base.  Changes
(increases) of numbers like "Reallocated Sectors", ""Current Pending
Sectors" or ""Offline Uncorrectable Sectors" are always suspicious.
If they increase just by one, and then stay constant for weeks you
can probably ignore it.  But if you see I/O errors in the system
logs and/or "Reallocated Sectors" increasing every few days then you
should not wait much longer and replace the respective drive.

Attached are two very simple scripts I use for this purpose;
"disk-test" simply runs smartctl on all /dev/sd? devices and parses
the output.  The result is something like this:

$ sudo disk-test
=== /dev/sda : ST1000NM0011 S/N Z1N2RA6E *** ERRORS ***
        Reallocated Sectors:     1
=== /dev/sdb : ST2000NM0033-9ZM175 S/N Z1X1J1K9 OK
=== /dev/sdc : ST2000NM0033-9ZM175 S/N Z1X1JEF6 OK
=== /dev/sdd : ST2000NM0033-9ZM175 S/N Z1X4XSN9 OK
=== /dev/sde : ST2000NM0033-9ZM175 S/N Z1X4X6G8 OK
=== /dev/sdf : ST2000NM0033-9ZM175 S/N Z1X54EA1 OK
=== /dev/sdg : ST2000NM0033-9ZM175 S/N Z1X5443W OK
=== /dev/sdh : ST2000NM0033-9ZM175 S/N Z1X4XAHQ OK
=== /dev/sdi : ST2000NM0033-9ZM175 S/N Z1X4X6NB OK
=== /dev/sdj : TOSHIBA MK1002TSKB S/N 32E3K0K2F OK
=== /dev/sdk : TOSHIBA MK1002TSKB S/N 32F3K0PRF OK
=== /dev/sdl : TOSHIBA MK1002TSKB S/N 32H3K10CF *** ERRORS ***
        Reallocated Sectors:     1
=== /dev/sdm : TOSHIBA MK1002TSKB S/N 32H3K0ZLF OK
=== /dev/sdn : TOSHIBA MK1002TSKB S/N 32H3K104F OK
=== /dev/sdo : TOSHIBA MK1002TSKB S/N 32H1K31DF OK
=== /dev/sdp : TOSHIBA MK1002TSKB S/N 32F3K0PUF OK
=== /dev/sdq : TOSHIBA MK1002TSKB S/N 32E3K0JZF OK

Here I have two drives with 1 reallocated sector each, which I
consider harmeless as it has stayed constant for several months.

The second script "disk-watch" is intended to be run as a cron job
on a regular base (here usually twice per day).  It will send out
email whenever the state changes (don't forget to adjust the MAIL_TO
setting).  You may also want to clean up the entries in /var/log/diskwatch
every now and then (or better add it to your logrotate
configuration).

HTH.


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Yes, it's a technical challenge, and  you  have  to  kind  of  admire
people  who go to the lengths of actually implementing it, but at the
same time you wonder about their IQ...
         --  Linus Torvalds in <5phda5$ml6$1@palladium.transmeta.com>


--==_Exmh_1498655662_67180
Content-Type: text/plain ; name="disk-test"
Content-Description: disk-test
Content-Disposition: attachment; filename="disk-test"

#!/bin/sh

DISKS="$(echo /dev/sd?)"

PATH=$PATH:/sbin:/usr/sbin

for i in ${DISKS}
do
	SMARTDATA=$(smartctl -a $i | \
	egrep 'Device Model:|Serial Number:|Reallocated_Sector_Ct|Current_Pending_Sector|Offline_Uncorrectable|failed|Unknown USB' | \
	grep -v ' -  *0$')
	LINES=$(echo "${SMARTDATA}" | wc -l)
	HEAD=$(echo "${SMARTDATA}" | \
	       sed -n -e 's/Device Model: //p' \
		      -e 's!Serial Number:!S/N!p')	
	BODY=$(echo "${SMARTDATA}" | \
	       awk '$2 ~ /Reallocated_Sector_Ct/	{ printf "Reallocated Sectors:   %3d\n", $10 }
		    $2 ~ /Current_Pending_Sector/	{ printf "Current Pending Sect:  %3d\n", $10 }
		    $2 ~ /Offline_Uncorrectable/	{ printf "Offline Uncorrectable: %3d\n", $10 }
		    $0 ~ /failed:.*AMCC/		{ printf "Unsupported AMCC/3ware controller\n" }
		    $0 ~ /SMART command failed/		{ printf "Device does not support SMART\n" }
		    $0 ~ /Unknown USB bridge/		{ printf "Unknown USB bridge\n" }
		'
	     )
	if [ $LINES -eq 2 ]
	then
		echo === $i : ${HEAD} OK
	else
		echo === $i : ${HEAD} "*** ERRORS ***"
		echo "${BODY}" | sed -e 's/^/	/'
	fi
done

--==_Exmh_1498655662_67180
Content-Type: text/plain ; name="disk-watch"
Content-Description: disk-watch
Content-Disposition: attachment; filename="disk-watch"

#!/bin/sh

D_TEST=/usr/local/sbin/disk-test
D_LOGDIR=/var/log/diskwatch
MAIL_TO="root"

[ -x ${D_TEST} ] || { echo "ERROR: cannot execute ${D_TEST}" >&2 ; exit 1 ; }

[ -d ${D_LOGDIR} ] || \
	mkdir -p ${D_LOGDIR} || \
		{ echo "ERROR: cannot create ${D_LOGDIR}" >&2 ; exit 1 ; }

cd ${D_LOGDIR} || { echo "ERROR: cannot cd ${D_LOGDIR}" >&2 ; exit 1 ; }

rm -f previous

[ -L latest ] && mv latest previous

NOW=$(date "+%F-%T")

${D_TEST} >${NOW}

ln -s "${NOW}" latest

DIFF=''

[ -r previous ] && DIFF=$(diff -u previous latest)

[ -z "${DIFF}" ] && exit 0

mailx -s "$(hostname): SMART DISK WARNING" ${MAIL_TO} <<+++
Disk status change:
${DIFF}

Recent results:
$(cat latest)
+++

--==_Exmh_1498655662_67180--


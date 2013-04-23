From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Tue, 23 Apr 2013 01:01:01 -0500
Message-ID: <5176239D.6060209@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5171CBF9.9020701@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/19/2013 5:58 PM, Andrei Banu wrote:
> Hardware: SuperMicro 5017C-MTRF

Not relevant if you're using SATA ports 0-1, but may well be if using
2-5, assuming this system isn't brand new.  As I said previously, you'd
see some errors in dmesg if you had port/cable issues.  From:

Intel=AE 6 Series Chipset and Intel=AE C200 Series Chipset Specificatio=
n Update


Problem:  Due to a circuit design issue on Intel 6 Series Chipset and
Intel C200 Series Chipset, electrical lifetime wear out may affect cloc=
k
distribution for SATA ports 2-5. This may manifest itself as a
functional issue on SATA ports 2-5 over time.

=95The electrical lifetime wear out may result in device oxide degradat=
ion
which over time can cause drain to gate leakage current.

=95This issue has time, temperature and voltage sensitivities.

Implication:  The increased leakage current may result in an unstable
clock and potentially functional issues on SATA ports 2-5 in the form o=
f
receive errors, transmit errors, and unrecognized drives.

=2E..
=95SATA ports 0-1 are not affected by this design issue as they have
separate clock generation circuitry.

Workaround:  Intel has worked with board and system manufacturers to
identify and implement solutions for affected systems.

=95Use only SATA ports 0-1.
=95Use an add-in PCIe SATA bridge solution.


Not all boards are affected by this.  You'd have to check the spec
revision on your C202, which means contacting SuperMicro with your boar=
d
revision/serial number.  To be certain you're not affected simply use
only ports 0-1.  But on that note...

It may be an opportune time to consider dropping in a LSI 9211-4i.
4GB/s raw throughput, plenty for 4 SSDs at full boogie should you
expand.  The kit version comes with a 1-4 breakout cable for your 1U SM
chassis drive backplane.  Even if we get your issue fixed via software
and both drives are humming away at ~260MB/s, that nightly backup
process you mentioned, and others, would surely benefit from an
additional ~200MB/s throughput.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

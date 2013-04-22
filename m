From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Mon, 22 Apr 2013 18:25:04 -0500
Message-ID: <5175C6D0.3030901@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51747382.1010105@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Andrei Banu <andrei.banu@redhost.ro>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/21/2013 6:17 PM, Stan Hoeppner wrote:

> It may not be necessary, at least to solve any SSD performance problems
> anyway.  Reexamining your numbers shows you hit 262MB/s to /dev/sda.
> That's 65% of SATA2 interface bandwidth, so this kernel probably does
> have the patch.  Your problem lie elsewhere.

Big correction.  That should state 87% of SATA2 interface bandwidth.  I
must have been thinking of three things at once when I fubar'd that, as
that's not simply a typo.

-- 
Stan



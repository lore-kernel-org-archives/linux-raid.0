From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Network based (iSCSI) RAID1 setup
Date: Wed, 10 May 2017 12:25:18 +0200
Message-ID: <fb55f684-d7a3-e31a-fcb3-602d8a058c5c@assyoma.it>
References: <dc2c3583-14da-435b-0177-8cee749a1cd0@assyoma.it>
 <20170510140323.256edb95@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170510140323.256edb95@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/05/2017 11:03, Roman Mamedov wrote:
> First thing that comes to mind, you should look into setting the remote device
> as --write-mostly, so that the local one is preferred for all reads (as long as
> it's up).

Sure, and it is planned. However, for initial testing, I want to leave 
as many parameters to their default settings.

> But to be honest DRBD may indeed be a better solution for this use case, as
> it's built specifically with it in mind, and likely has all the various
> gotchas that might arise already thought about and handled properly.
>

To tell the truth, I already use DRBD 8.4 in production workloads and I 
are quite satisfied with it. However, DRBD 8.4 only supports 2 hosts 
(ie: master and slave), and DRBD 9.x (which supports multi-node 
replication) is a relatively new, deep re-write of the old codebase 
which significantly expanded scope.

So my interest in mdadm-based network replication...

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8

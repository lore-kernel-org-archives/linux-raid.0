From: jes.sorensen@gmail.com
Subject: Re: [PATCH v4 0/6] mdadm support for Partial Parity Log
Date: Wed, 29 Mar 2017 11:39:47 -0400
Message-ID: <wrfjy3vodrcs.fsf@gmail.com>
References: <20170329095420.17855-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170329095420.17855-1-artur.paszkiewicz@intel.com> (Artur
        Paszkiewicz's message of "Wed, 29 Mar 2017 11:54:14 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> This is the mdadm part of the PPL functionality. It adds a new parameter to
> mdadm to allow selecting the consistency policy for an array and implements PPL
> as one of the policies.
>
> All of this is currently targeted and tested with imsm and super1 metadata
> arrays. The kernel patches are available on Shaohua's md tree on the for-next
> branch.

Applied!

This time I got them all - I added one little patch on top which
reorganized the ppl elements in struct mdinfo for slightly better
packing.

Thanks,
Jes

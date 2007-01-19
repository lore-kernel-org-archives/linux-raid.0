From: Luca Berra <bluca@comedia.it>
Subject: Re: upgrade to mdadm 2.6 x86_64 issues
Date: Fri, 19 Jan 2007 08:30:36 +0100
Message-ID: <20070119073036.GC31075@percy.comedia.it>
References: <167578845.1169169737952.JavaMail.root@gateway.korstad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <167578845.1169169737952.JavaMail.root@gateway.korstad.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 18, 2007 at 07:22:17PM -0600, Daniel Korstad wrote:
>Lines 579 thru 582
>
>578 (sbv + 1024 + sizeof(struct bitmap_super_s));
>579 printf("Size was %llu\n", __le64_to_cpu(sb->data_size));
>580 sb->data_size = __cpu_to_le64(
>581 misc->device_size - __le64_to_cpu(sb->data_offse t));
>582 printf("Size is %llu\n", __le64_to_cpu(sb->data_size));
>583 }
>
in other places in the code this was fixed previously to use a cast to
ull type, replace the above with:

578 (sbv + 1024 + sizeof(struct bitmap_super_s));
579 printf("Size was %llu\n", (unsigned long long)__le64_to_cpu(sb->data_size));
580 sb->data_size = __cpu_to_le64(
581 misc->device_size - __le64_to_cpu(sb->data_offse t));
582 printf("Size is %llu\n", (unsigned long long)__le64_to_cpu(sb->data_size));
583 }

regards,
L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

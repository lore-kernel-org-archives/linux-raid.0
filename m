From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 16:16:12 +0100
Message-ID: <52BD99BC.8000205@assyoma.it>
References: <52BD8EDD.10809@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52BD8EDD.10809@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 > It does not matter (except to people writing MD-specific tools).
 > There is nothing special as to the ordering of drives or chunks
 > on drives. Also reliability is a *statistical* property not a
 > geometric one...

Uhm, why it don't matter? For clarity, let me redraw the two schemas:

1) A1 A2 A3 A4
    .. .. .. ..
    A4 A1 A2 A3

2) A1 A2 A3 A4
    .. .. .. ..
    A2 A1 A4 A3

Schema n.1 will fail on any adjacent disk failure. Eg: 1 & 2, 2 & 3, 3 & 
4, 4 & 1.

On the other hand, schema n.2 will become inactive only when 1 & 2 or 3 
& 4 disk fail, but not, for example, when 2 & 3 or 1 & 4 fail.

Or I misunderstand something?

 > That "consecutive two-disk failures" is really funny!

Er, my English is not very good :p
I really was talking about adjacent disk failures. Sorry!

 > If two-paired-disk failure in RAID10 bother you, try RAID14:
 >
 >  http://www.sabi.co.uk/blog/13-two.html#131213
 >
 > Warning: that does not come at no cost :-).

Thank you very mych for the link! I need some time to read it carefully...

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8

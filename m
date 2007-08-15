From: David Greaves <david@dgreaves.com>
Subject: Re: SWAP file on a RAID-10 array possible?
Date: Wed, 15 Aug 2007 11:10:09 +0100
Message-ID: <46C2D101.8050205@dgreaves.com>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com><5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com><c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com><18104.18410.623573.929770@notabene.brown><c70ff3ad0708070332n33296a9cp719a6e1b8860ec4b@mail.gmail.com><c70ff3ad0708070346u4b538be9j6d1b5cf83f535de6@mail.gmail.com><18104.21737.341407.654022@notabene.brown><c70ff3ad0708070431v3ba47ab0j533197d92aea884c@mail.gmail.com> <18104.23111.369229.891505@notabene.brown> <02a201c7df1b$07dec720$332317ac@Cortex>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02a201c7df1b$07dec720$332317ac@Cortex>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas France <tomfra@centrum.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomas France wrote:
> Hi everyone,
> 
> I apologize for asking such a fundamental question on the Linux-RAID 
> list but the answers I found elsewhere have been contradicting one another.
> 
> So, is it possible to have a swap file on a RAID-10 array?
yes.

mkswap /dev/md<X>
swapon /dev/md<X>

Should you use RAID-10 for swap? That's philosophy :)

David

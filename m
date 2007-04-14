From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: Moron Destroyed RAID6 Array Superblocks
Date: Sat, 14 Apr 2007 00:28:05 -0700
Message-ID: <46208285.80801@fatooh.org>
References: <200704081521.l38FLwGU017164@cichlid.com> <1176519568.7325.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1176519568.7325.3.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: "Aaron C. de Bruyn" <aaron@darkpixel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Aaron C. de Bruyn wrote:
> Ok--I got moved in to my new place and am back and running on the 'net.
> I sat down for a few hours and attempted to write a script to try all
> possible combinations of drives...but I have to admit that I'm lost.
> 
> I have 8 drives in the array--and I can output every possible
> combination of those.  But what the heck would be the logic to output
> all combinations of the 8 drives using only 6 at a time?  My head hurts.

You want only 5 at a time, don't you?
8 drives - 1 spare - 2 parity = 5

Anyway, a very quick-n-dirty way to get what you want is to:
1. calculate all permutations
2. strip away the last items of each permutation
3. get rid of duplicate lines

$ wget http://hayne.net/MacDev/Perl/permutations
$ perl permutations a b c d e f g h | cut -d' ' -f-5 | sort -u

The Perl script above is from:
http://hayne.net/MacDev/Perl/

-Corey

From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Fri, 07 Jan 2005 15:21:08 +0900
Message-ID: <41DE2A54.1010902@tequila.co.jp>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <v3rda2-hjn.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/31/2004 02:39 AM, Peter T. Breuer wrote:
> In gmane.linux.raid Georg C. F. Greve <greve@fsfeurope.org> wrote:
> 
>>The message I saw on the remote console when it crashed with pure ext3
>>on raid5 was:
>>
>> Assertion failure in journal_start() at fs/jbd/transaction.c:271: "handle->h_transaction->t_journal == journal"
>>
> 
> Yes, well, don't put the journal on the raid partition. Put it
> elsewhere (anyway, journalling and raid do not mix, as write ordering
> is not - deliberately - preserved in raid, as far as I can tell).

Thats a very new claim. I never ever heard of that. I have a lot of
boxes running with software raid (1 or 5) and they run either XFS or
ext3 on it, and since one year I never had a single problem (and they
all use 2.6.7 or 2.6.8.1 kernels).

- --
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TBWA\ && TEQUILA\ Japan IT Group                           ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-0061, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp        http://www.tbwajapan.co.jp ]
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFB3ipTjBz/yQjBxz8RAsExAJ9ZhniY/vsm9TIpRtHhGsfdVjws6wCeO4RS
rJ/o4roBjSBo3z5os/E6tKk=
=d3Rn
-----END PGP SIGNATURE-----

From: Robert Kierski <rkierski@cray.com>
Subject: RE: best base / worst case RAID 5,6 write speeds
Date: Fri, 15 Jan 2016 16:53:17 +0000
Message-ID: <F7761B9B1D11B64BBB666019E9378117FEA066@CFWEX01.americas.cray.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
 <CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
 <CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
 <CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
 <CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
 <CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
 <CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
 <22128.11867.847781.946791@quad.stoffel.home>
 <CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
 <22128.35881.182823.556362@quad.stoffel.home>
 <CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
 <CAE9DZUQqeCY__+8Fwg51PJc6zAk0J2Apm2TE3CRvxbFUf-xDKQ@mail.gmail.com>
 <CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
 <5672BB7A.4050808@turmel.org>
 <CAE9DZUQj2TNX4Wpk5xbaCVzEgPq2D6Co7ZDNaAy-TOaB4hwZeA@mail.gmail.com>
 <567339F0.9000209@turmel.org>
 <CAE9DZUS+gmgTLr_4EUgLcPCPWknoqg640mCMZX46cxXeyT6RQA@mail.gmail.com>
 <CAE9DZUQoYtt3U5rGBAUtTuLS2N2uA80e=EcDD73fHq0qn6YH2w@mail.gmail.com>
 <CAFx4rwT8xgwZ0OWaLLsZvhMskiwmY54MzHgnnEPaswByeRrXxQ@mail.gmail.com>
 <CAFx4rwTUiMo=1+JXpY3P5BhZYSQC8MVYhTJfdJd7gL6r9WSAiA@mail.gmail.com>
 <CAE9DZUQoNh2uU1h4okY0Fz5wzVv6-ZTnet9tS-dNQRHsLnPvNg@mail.gmail.com>
 <CAFx4rwQvTrUEskJxdc6CpvGu3uVYOJWEvHmMkqmNbmTgTVT0-Q@mail.gmail.com>
 <F7761B9B1D11B64BBB666019E9378117FE79E5@CFWEX01.americas.cray.com>
 <CAFx4rwQ+3w3v-QmiYoQu=5aApc4KyiykF+KdtMUG4v6-fBh22g@mail.gmail.com>
 <F7761B9B1D11B64BBB666019E9378117FE7AB1@CFWEX01.americas.cray.com>
 <CAFx4rwSo3MNqJGNQ3wHe49F+xQ6559aZdikPL4M3+HuD6uRz-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwSo3MNqJGNQ3wHe49F+xQ6559aZdikPL4M3+HuD6uRz-Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "doug@easyco.com" <doug@easyco.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

SGV5IERvdWcsDQoNCkkgdHJpZWQgYXMgeW91IHN1Z2dlc3RlZC4uLiBvbmx5IHRoYXQgZGlkbid0
IGhlbHAuICBTbyBJIGFjdHVhbGx5IGhhZCB0byBnZXQgZG93biBpbnRvIHRoZSBndXRzIHRvIGZp
Z3VyZSBvdXQgd2hhdCB3YXMgZ29pbmcgd3JvbmcuDQoNCkl0IHR1cm5lZCBvdXQgdG8gYmUgYSBi
dWcgaW4gdGhlIGJsb2NrIGxheWVyIG9mIHRoZSAzLjE4IGtlcm5lbCB0aGF0IHJlcXVpcmVkIGEg
b25lIGxpbmUgY2hhbmdlLiAgV2l0aCB0aGF0IGZpeGVkLCB0aGUgRmFzdFdyaXRlIHBhdGNoIHdv
cmtzIGxpa2UgYSBjaGFybS4NCg0KVGhhbmtzIQ0KDQpCb2IgS2llcnNraQ0KU2VuaW9yIFN0b3Jh
Z2UgUGVyZm9ybWFuY2UgRW5naW5lZXINCkNyYXkgSW5jLg0KMzgwIEphY2tzb24gU3RyZWV0DQpT
dWl0ZSAyMTANClN0LiBQYXVsLCBNTiA1NTEwMQ0KVGVsZTogNjUxLTk2Ny05NTkwDQpGYXg6ICA2
NTEtNjA1LTkwMDENCkNlbGw6IDY1MS04OTAtNzQ2MQ0KDQo=

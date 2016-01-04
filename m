From: Robert Kierski <rkierski@cray.com>
Subject: RE: best base / worst case RAID 5,6 write speeds
Date: Mon, 4 Jan 2016 19:33:10 +0000
Message-ID: <F7761B9B1D11B64BBB666019E9378117FE7AB1@CFWEX01.americas.cray.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwQ+3w3v-QmiYoQu=5aApc4KyiykF+KdtMUG4v6-fBh22g@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "doug@easyco.com" <doug@easyco.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

SGV5IERvdWcsDQoNCkkgdHJpZWQgYWxsIHNvcnRzIG9mIHRoaW5ncy4uLiBldmVuIHRoaW5ncyB0
aGF0IHNlZW1lZCByYXRoZXIgYmFja3dhcmRzLiAgSSB0cmllZCBhIHZhcmlldHkgb2YgZGlzayBj
b3VudCdzLCBjaHVuayBzaXplcywgSU8gc2l6ZXMsIElPIENvdW50cywgZXRjLiAgDQoNClllcy4u
LnRoZSBjaGFuZ2VzIHdlcmUgYWRkaW5nIHRoZSBiaV9pdGVyIChtb3N0bHkpLg0KDQpJIGFsc28g
ZWxpbWluYXRlZCB0aGUgbGltaXQgb2YgMTAgcHJpbnRrJ3Mgc28gdGhhdCBJIGNvdWxkIHRyeSB2
YXJpb3VzIE1EUmFpZCBjb25maWd1cmF0aW9ucyBhbmQgdmFyaW91cyBibG9jayBzaXplIGFuZCBj
b3VudHMgd2l0aG91dCBoYXZpbmcgdG8gcmVib290Lg0KDQpJIHdvdWxkIGhhdmUgdGhvdWdodCB0
aGF0IHRoZSBPUyB3b3VsZCBwYXNzIHRoZSBJTyBmcm9tIHVzZXIgc3BhY2UgdG8gdGhlIGRyaXZl
ciB3aXRob3V0IG1vZGlmaWNhdGlvbi4gIEJ1dCBpdCBhcHBlYXJzIHRoYXQncyBub3QgdGhlIGNh
c2UuDQoNCkJvYiBLaWVyc2tpDQpTZW5pb3IgU3RvcmFnZSBQZXJmb3JtYW5jZSBFbmdpbmVlcg0K
Q3JheSBJbmMuDQozODAgSmFja3NvbiBTdHJlZXQNClN1aXRlIDIxMA0KU3QuIFBhdWwsIE1OIDU1
MTAxDQpUZWxlOiA2NTEtOTY3LTk1OTANCkZheDogIDY1MS02MDUtOTAwMQ0KQ2VsbDogNjUxLTg5
MC03NDYxDQoNCg==

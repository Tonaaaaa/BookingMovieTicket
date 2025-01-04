﻿// <auto-generated />
using System;
using Backend.DataAccess;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace Backend.Migrations
{
    [DbContext(typeof(ApplicationDbContext))]
    [Migration("20241221180159_reupdatabase6")]
    partial class reupdatabase6
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.2")
                .HasAnnotation("Relational:MaxIdentifierLength", 64);

            MySqlModelBuilderExtensions.AutoIncrementColumns(modelBuilder);

            modelBuilder.Entity("Backend.Models.Actor", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("ProfilePictureUrl")
                        .HasColumnType("longtext");

                    b.Property<string>("Role")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Actors");
                });

            modelBuilder.Entity("Backend.Models.Booking", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("PaymentMethod")
                        .HasColumnType("longtext");

                    b.Property<string>("PaymentProviderData")
                        .HasColumnType("longtext");

                    b.Property<string>("PaymentTransactionId")
                        .HasColumnType("longtext");

                    b.Property<string>("PaymentUrl")
                        .HasColumnType("longtext");

                    b.Property<int>("ShowtimeId")
                        .HasColumnType("int");

                    b.Property<string>("Status")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<decimal>("TotalPrice")
                        .HasColumnType("decimal(10, 2)");

                    b.Property<DateTime>("UpdatedAt")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasColumnType("varchar(255)");

                    b.Property<string>("ZaloPayTransToken")
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.HasIndex("ShowtimeId");

                    b.HasIndex("UserId");

                    b.ToTable("Bookings");
                });

            modelBuilder.Entity("Backend.Models.Comment", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Content")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime(6)");

                    b.Property<int>("MovieId")
                        .HasColumnType("int");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Comments");
                });

            modelBuilder.Entity("Backend.Models.Movie", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("AgeRating")
                        .HasColumnType("longtext");

                    b.Property<string>("BannerUrl")
                        .HasColumnType("longtext");

                    b.Property<string>("Description")
                        .HasColumnType("longtext");

                    b.Property<int>("DurationInMinutes")
                        .HasColumnType("int");

                    b.Property<string>("FormatsInDb")
                        .HasColumnType("longtext");

                    b.Property<string>("GenresInDb")
                        .HasColumnType("longtext");

                    b.Property<string>("LanguagesAvailableInDb")
                        .HasColumnType("longtext");

                    b.Property<int>("Like")
                        .HasColumnType("int");

                    b.Property<DateTime>("ReleaseDate")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("Status")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("TrailerUrl")
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Movies");
                });

            modelBuilder.Entity("Backend.Models.MovieActor", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("ActorId")
                        .HasColumnType("int");

                    b.Property<int>("MovieId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("ActorId");

                    b.HasIndex("MovieId");

                    b.ToTable("MovieActors");
                });

            modelBuilder.Entity("Backend.Models.Screen", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("TheatreId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("TheatreId");

                    b.ToTable("Screens");
                });

            modelBuilder.Entity("Backend.Models.Seat", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Arrangement")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("ScreenId")
                        .HasColumnType("int");

                    b.Property<int>("ShowtimeId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("ScreenId");

                    b.HasIndex("ShowtimeId");

                    b.ToTable("Seats");
                });

            modelBuilder.Entity("Backend.Models.SeatDetail", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<decimal>("AdditionalPrice")
                        .HasColumnType("decimal(65,30)")
                        .HasAnnotation("Relational:JsonPropertyName", "additionalPrice");

                    b.Property<int?>("BookingId")
                        .HasColumnType("int");

                    b.Property<string>("LinkedSeatNumber")
                        .HasColumnType("longtext")
                        .HasAnnotation("Relational:JsonPropertyName", "linkedSeatNumber");

                    b.Property<string>("SeatNumber")
                        .IsRequired()
                        .HasColumnType("longtext")
                        .HasAnnotation("Relational:JsonPropertyName", "seatNumber");

                    b.Property<string>("Status")
                        .IsRequired()
                        .HasColumnType("longtext")
                        .HasAnnotation("Relational:JsonPropertyName", "status");

                    b.Property<string>("Type")
                        .IsRequired()
                        .HasColumnType("longtext")
                        .HasAnnotation("Relational:JsonPropertyName", "type");

                    b.HasKey("Id");

                    b.HasIndex("BookingId");

                    b.ToTable("SeatDetails");
                });

            modelBuilder.Entity("Backend.Models.Showtime", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("MovieId")
                        .HasColumnType("int");

                    b.Property<decimal?>("PriceModifier")
                        .HasColumnType("decimal(5, 2)");

                    b.Property<int>("ScreenId")
                        .HasColumnType("int");

                    b.Property<DateTime>("StartTime")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("Status")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("TheatreId")
                        .HasColumnType("int");

                    b.Property<decimal>("TicketPrice")
                        .HasColumnType("decimal(10, 2)");

                    b.HasKey("Id");

                    b.HasIndex("MovieId");

                    b.HasIndex("ScreenId");

                    b.HasIndex("TheatreId");

                    b.ToTable("Showtimes");
                });

            modelBuilder.Entity("Backend.Models.SnackPackage", b =>
                {
                    b.Property<Guid>("SnackPackageId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("char(36)");

                    b.Property<int?>("BookingId")
                        .HasColumnType("int");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("Description")
                        .HasColumnType("longtext");

                    b.Property<string>("ImageUrl")
                        .HasMaxLength(255)
                        .HasColumnType("varchar(255)");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("varchar(100)");

                    b.Property<decimal>("Price")
                        .HasColumnType("decimal(65,30)");

                    b.Property<int>("Quantity")
                        .HasColumnType("int");

                    b.Property<DateTime?>("UpdatedAt")
                        .HasColumnType("datetime(6)");

                    b.HasKey("SnackPackageId");

                    b.HasIndex("BookingId");

                    b.ToTable("SnackPackages");
                });

            modelBuilder.Entity("Backend.Models.Theatre", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    MySqlPropertyBuilderExtensions.UseMySqlIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("AvailableScreens")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("City")
                        .HasColumnType("longtext");

                    b.Property<string>("ContactNumber")
                        .HasColumnType("longtext");

                    b.Property<string>("Coordinates")
                        .HasColumnType("longtext");

                    b.Property<string>("Facilities")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("FullAddress")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("ImageUrl")
                        .HasColumnType("longtext");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Theatres");
                });

            modelBuilder.Entity("Backend.Models.User", b =>
                {
                    b.Property<string>("UserId")
                        .HasColumnType("varchar(255)");

                    b.Property<string>("AvatarUrl")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Phone")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Role")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("UserId");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("Backend.Models.Booking", b =>
                {
                    b.HasOne("Backend.Models.Showtime", "Showtime")
                        .WithMany()
                        .HasForeignKey("ShowtimeId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Backend.Models.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Showtime");

                    b.Navigation("User");
                });

            modelBuilder.Entity("Backend.Models.MovieActor", b =>
                {
                    b.HasOne("Backend.Models.Actor", "Actor")
                        .WithMany("MovieActors")
                        .HasForeignKey("ActorId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Backend.Models.Movie", "Movie")
                        .WithMany("MovieActors")
                        .HasForeignKey("MovieId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Actor");

                    b.Navigation("Movie");
                });

            modelBuilder.Entity("Backend.Models.Screen", b =>
                {
                    b.HasOne("Backend.Models.Theatre", "Theatre")
                        .WithMany("Screens")
                        .HasForeignKey("TheatreId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Theatre");
                });

            modelBuilder.Entity("Backend.Models.Seat", b =>
                {
                    b.HasOne("Backend.Models.Screen", "Screen")
                        .WithMany()
                        .HasForeignKey("ScreenId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Backend.Models.Showtime", "Showtime")
                        .WithMany()
                        .HasForeignKey("ShowtimeId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Screen");

                    b.Navigation("Showtime");
                });

            modelBuilder.Entity("Backend.Models.SeatDetail", b =>
                {
                    b.HasOne("Backend.Models.Booking", null)
                        .WithMany("Seats")
                        .HasForeignKey("BookingId");
                });

            modelBuilder.Entity("Backend.Models.Showtime", b =>
                {
                    b.HasOne("Backend.Models.Movie", "Movie")
                        .WithMany("Showtimes")
                        .HasForeignKey("MovieId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Backend.Models.Screen", "Screen")
                        .WithMany("Showtimes")
                        .HasForeignKey("ScreenId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Backend.Models.Theatre", "Theatre")
                        .WithMany("Showtimes")
                        .HasForeignKey("TheatreId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Movie");

                    b.Navigation("Screen");

                    b.Navigation("Theatre");
                });

            modelBuilder.Entity("Backend.Models.SnackPackage", b =>
                {
                    b.HasOne("Backend.Models.Booking", null)
                        .WithMany("Snacks")
                        .HasForeignKey("BookingId");
                });

            modelBuilder.Entity("Backend.Models.Actor", b =>
                {
                    b.Navigation("MovieActors");
                });

            modelBuilder.Entity("Backend.Models.Booking", b =>
                {
                    b.Navigation("Seats");

                    b.Navigation("Snacks");
                });

            modelBuilder.Entity("Backend.Models.Movie", b =>
                {
                    b.Navigation("MovieActors");

                    b.Navigation("Showtimes");
                });

            modelBuilder.Entity("Backend.Models.Screen", b =>
                {
                    b.Navigation("Showtimes");
                });

            modelBuilder.Entity("Backend.Models.Theatre", b =>
                {
                    b.Navigation("Screens");

                    b.Navigation("Showtimes");
                });
#pragma warning restore 612, 618
        }
    }
}
